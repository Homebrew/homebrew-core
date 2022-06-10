class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.0/proteinortho-v6.1.0.tar.gz"
  sha256 "4c087cbfd91051136df808a679694ab2ada3c266c175b4187689f302e8ccf8ac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61d9ca433c614a5c4785b340b918533e5058bd521dbb7730442cb9d8724ccc33"
    sha256 cellar: :any,                 arm64_big_sur:  "e27b32e5c4601009c33251b813dc1f062f391ea7e9065ccf90f85836f786dcdf"
    sha256 cellar: :any,                 monterey:       "180ab82f443e1df126ebe112b8eb0b186bed2a1bdd264fb5c0debb95718ba35c"
    sha256 cellar: :any,                 big_sur:        "ba3144f596ae203536ac9898305d2324f747faf64a6f54f64260e64e59670d90"
    sha256 cellar: :any,                 catalina:       "7cdf1d14bf86e7c6160fb228abbe2fce11d4814c385d240810c1d0b14a24a297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cdc6240b097f209e3b06d0a5a17a75ece7960518ade778870b26813e7b21317"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
