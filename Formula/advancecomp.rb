class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v2.0.tar.gz"
  sha256 "caa63332cd141db17988eb89c662cf76bdde72f60d4de7cb0fe8c7e51eb40eb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6be5afcb1aeb0c8f6ce37bc528cfd27755b09043d052580b1e4a89cb954f341" => :sierra
    sha256 "d4fe20402a495811acd27c98ce7c5c8c7329a4596b5d1f6cef345c4ecb3f8e5c" => :el_capitan
    sha256 "4106a08a195345033e4e5481f28091895fd297a334aa622851678a98689dd34d" => :yosemite
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
