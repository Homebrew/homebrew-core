class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.8.5/lnav-0.8.5.tar.gz"
  sha256 "bb809bc8198d8f7395f3de76efdc1a08a5c2c97dc693040faee38802c38945de"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2c6e7bd10eb78c6f476739be3e106012d6decce1d8ff1ae1a51c55f3cea2c688" => :mojave
    sha256 "bc796136677ca2b4bee92decf2d517ee0a92a6ea2d476b45a350d5aff367c948" => :high_sierra
    sha256 "91968b3b06733d667459ca2ffb81e82b91d10e4710c22f72a739e2eed203ba1e" => :sierra
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
