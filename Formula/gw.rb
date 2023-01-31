class Gw < Formula
  desc "Browser for genomic sequencing data and variants"
  homepage "https://github.com/kcleal/gw"
  url "https://github.com/kcleal/gw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8b6b85b337602052b4ca2a3259152f1be56ffab97c6b6a0150046d7a1bbf4333"
  license "MIT"
  depends_on "fontconfig"
  depends_on "glfw"
  depends_on "htslib"
  depends_on "icu4c"
  depends_on "wget"
  depends_on "zlib"

  def install
    system "bash", "build_skia.sh"
    system "make"
    bin.install "gw"
    bin.install ".gw.ini"
  end

  test do
    system "gw", "--version"
  end
end
