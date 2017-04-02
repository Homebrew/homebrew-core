class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v1.23.tar.gz"
  sha256 "fe89d6ab382efc6b6be536b8d58113f36b83d82783d5215c261c14374cba800a"

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
