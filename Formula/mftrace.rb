class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "80eaec2570ed7efc70d82e7a2b8ca9413d6a6b0ab8157c8364c9ae0cfb2a163a" => :mojave
    sha256 "f81be9cddecffd87a3066f23f90cb1be41ad2d43709a44e59c2d8f645ec4136c" => :high_sierra
    sha256 "60d36f222820ef0ffa00c3c67f8fc7d9063472062c8771b99bf783781e9c5613" => :sierra
    sha256 "ca26dc49c3a032568dea9c0a5a7639bd8a117f8f8e052a411679b78d01811e1f" => :el_capitan
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "t1utils"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
