class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v1.23.tar.gz"
  sha256 "fe89d6ab382efc6b6be536b8d58113f36b83d82783d5215c261c14374cba800a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff4d62b3b8b0c90df02d65ecf1bd6bbfb923cbffe4a03aa080c870199e723f9e" => :sierra
    sha256 "da7379176da00e673a7719a794f257cc835f1d1c7f85fab7688dea503a7f9e76" => :el_capitan
    sha256 "84eb20d542907c22b5695afe49f3c305b668ab5efcf78a1fe9776b1bd70854cf" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
