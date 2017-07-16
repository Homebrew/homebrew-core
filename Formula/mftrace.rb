class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e7a7fbdc4271c85405debec19621dc71b3665925e5915090ad1f16037775e454" => :sierra
    sha256 "1d89d94a65434990494709f9488f3a2847f5dc4a8b3f5e8b26a64cf3437bf583" => :el_capitan
    sha256 "a0319882dcc7a8e51556b0d05c22b09309ac418eacf6318fbde474dea41ce2c4" => :yosemite
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "potrace"
  depends_on "t1utils"
  depends_on "fontforge" => [:recommended, :run]

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
