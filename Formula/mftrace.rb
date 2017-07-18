class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d40276096fa89ede34b52422927a59de191ff28ccc7221185658534591c9714b" => :sierra
    sha256 "d667c5bfe7ce0e9552ad0aee73089664d9d60ea21db8baeda8a32d0fe7794698" => :el_capitan
    sha256 "ecaf0915cd7a5917e4f6c095e1f5e031dd8cc26ff637f7c62c65fd2c14fc4f9a" => :yosemite
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
