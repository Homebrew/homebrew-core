class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.1.1/pandoc-plot-1.1.1.tar.gz"
  sha256 "00b67fda0d7faa2da6a149d4e69d1f547036ba5dd55f4bbbacf0ce714f649c83"
  license "GPL-2.0-or-later"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system "#{bin}/pandoc-plot", "toolkits"
  end
end
