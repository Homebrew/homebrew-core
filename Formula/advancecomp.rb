class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v2.1.tar.gz"
  sha256 "6113c2b6272334af710ba486e8312faa3cee5bd6dc8ca422d00437725e2b602a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e02eb49cfa3587545852bb5412ec4bed7a5a23bf7348798aa508fb1fe3c3840" => :high_sierra
    sha256 "0142bd73b77ee344b76be047323dea7593a03ee08b7041f789d8e1a330c5f7ec" => :sierra
    sha256 "adf23429f3c808c367520a4225caee3b2c7a2a8c4dea5bc8b28c8654f7e5b989" => :el_capitan
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
