require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/scoring'

# Get that nice colorized output
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe 'Scoring' do
  describe 'score' do
    it 'correctly scores simple words' do
      Scrabble::Scoring.score('dog').must_equal 5
      Scrabble::Scoring.score('cat').must_equal 5
      Scrabble::Scoring.score('pig').must_equal 6
    end

    it 'adds 50 points for a 7-letter word' do
      Scrabble::Scoring.score('academy').must_equal 65
    end

    it 'handles all upper- and lower-case letters' do
      Scrabble::Scoring.score('dog').must_equal 5
      Scrabble::Scoring.score('DOG').must_equal 5
      Scrabble::Scoring.score('DoG').must_equal 5
    end

    it 'returns nil for strings containing bad characters' do
      Scrabble::Scoring.score('#$%^').must_be_nil
      Scrabble::Scoring.score('char^').must_be_nil
      Scrabble::Scoring.score(' ').must_be_nil
    end

    it 'returns nil for words > 7 letters' do
      Scrabble::Scoring.score('abcdefgh').must_be_nil
    end

    it 'returns nil for empty words' do
      Scrabble::Scoring.score('').must_be_nil
    end
  end

  describe 'highest_score_from' do
    it 'returns nil if no words were passed' do
      # Act
      word_collection = []
      # Assert
      Scrabble::Scoring.highest_score_from(word_collection).must_be_nil
    end

    it 'returns the only word in a length-1 array' do
      # Act
      word_collection = ["dog"]
      word_collection2 = ["mouse"]
      # Assert
      Scrabble::Scoring.highest_score_from(word_collection).must_equal "dog"
      Scrabble::Scoring.highest_score_from(word_collection2).must_equal "mouse"
    end

    it 'returns the highest word if there are two words' do
      word_collection = ["dog","quiz","cat"]
      Scrabble::Scoring.highest_score_from(word_collection).must_equal "quiz"
    end

    it 'if tied, prefer a word with 7 letters' do
      #Act
        word_collection = ['kkb','markets','qm']
        word_collection2 = ["dogss", "treatss"]
      #Assert
      Scrabble::Scoring.highest_score_from(word_collection).must_equal "markets"
      Scrabble::Scoring.highest_score_from(word_collection2).must_equal "treatss"

    end

    it 'if tied and no word has 7 letters, prefers the word with fewer letters' do
      words = ["kf","bcm", "dgmae"]
      words2 = "kk", "q", "aeiouk"
      Scrabble::Scoring.highest_score_from(words).must_equal "kf"
      Scrabble::Scoring.highest_score_from(words2).must_equal "q"
    end

    it 'returns the first word of a tie with same letter count' do
      words = ["kf","bcm", "kh", "dgmae","kw"]
      Scrabble::Scoring.highest_score_from(words).must_equal "kf"

      words = ["bcm", "kh", "dgmae","kf"]
      Scrabble::Scoring.highest_score_from(words).must_equal "kh"
    end
  end
end
