class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v2.1.tar.gz"
  sha256 "6113c2b6272334af710ba486e8312faa3cee5bd6dc8ca422d00437725e2b602a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fe41182dbed3eba095f1262b22ab9e032020c9b1c4c6d603f7d0ff4b1c84f59" => :high_sierra
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
