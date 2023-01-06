class Gw < Formula
  desc "Browser for genomic sequencing data and variants"
  homepage "https://github.com/kcleal/gw"
  url "https://github.com/kcleal/gw/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b479e19c2fed0704a652c0fcbd653517ce01ac429ec7753c95a583c35a733012"
  license "MIT"
  depends_on "fontconfig"
  depends_on "glfw"
  depends_on "htslib"
  depends_on "icu4c"
  depends_on "wget"
  depends_on "zlib"

  def install
    system "make", "prep"
    system "sed -i.bak 's/lglfw/lglfw3/g' Makefile && make"
    bin.install "gw"
  end

  test do
    system "gw", "--version"
  end
end
