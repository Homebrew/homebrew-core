class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftpmirror.gnu.org/dejagnu/dejagnu-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.tar.gz"
  sha256 "00b64a618e2b6b581b16eb9131ee80f721baa2669fa0cdee93c500d1a652d763"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f6f667f06ed0a74f993668847f437e60f90397b0b1615ebbf0f930f7d2836d2" => :sierra
    sha256 "099657338971c6b84bf135f2935559a4753b2137edd807d777c999edaf0fb8d6" => :el_capitan
    sha256 "0d589e4ec11e3d8de7f00abcbb4a62b50e578e15e6d8fafd42371ca9550b04c8" => :yosemite
    sha256 "575e2565feb8d2d60c3163a1a8d38c4ba719fd5a523fc147a7812aed7f26fb88" => :mavericks
  end

  head do
    url "http://git.savannah.gnu.org/r/dejagnu.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.j1 # Or fails on Mac Pro
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/runtest"
  end
end
