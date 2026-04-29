class FairyStockfishXiangqiNnue < Formula
  desc "Xiangqi NNUE neural network for Fairy-Stockfish"
  homepage "https://github.com/fairy-stockfish/Fairy-Stockfish-NNUE"
  url "https://github.com/fairy-stockfish/Fairy-Stockfish-NNUE/raw/master/xiangqi-c07e94a5c7cb.nnue"
  version "2025-11-05"
  sha256 "c07e94a5c7cbeae443ed79a8fa412875d833a7f8e04333815e39729c59d52e11"
  license "GPL-3.0-or-later"

  def install
    share.install "xiangqi-c07e94a5c7cb.nnue"
  end

  def caveats
    <<~EOS
      After installation, Xiangqi NNUE file is at:
        #{opt_share}/xiangqi-c07e94a5c7cb.nnue

      In Fairy-Stockfish, set:
        setoption name EvalFile value #{opt_share}/xiangqi-c07e94a5c7cb.nnue
    EOS
  end

  test do
    assert_path_exists opt_share/"xiangqi-c07e94a5c7cb.nnue"
  end
end
