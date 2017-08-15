class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v2.0.tar.gz"
  sha256 "caa63332cd141db17988eb89c662cf76bdde72f60d4de7cb0fe8c7e51eb40eb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "91ccc9deafc27709e679cde5ce72a1d5086d765710495958bbdfc695a074511f" => :sierra
    sha256 "0b376386378fd8bea0864f6b5bb06abe38a7e4f1dfb6e22632a69c299c8238b1" => :el_capitan
    sha256 "1ee325f6dc47b3c17963372e31591442d6f977b8e20776a09f71cf7503e3bc5d" => :yosemite
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
