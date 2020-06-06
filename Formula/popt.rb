class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://github.com/rpm-software-management/popt"
  url "http://ftp.rpm.org/mirror/popt/popt-1.16.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    cellar :any
    rebuild 3
    sha256 "26d76db3d80802bbc9c93b935bea569d8640cb081d75ff58e240cc90cb0bdb5a" => :catalina
    sha256 "62d43c019e6968bc603f4e5ae323ca957d50bccb0d1e797eba6d411c8f3941e4" => :mojave
    sha256 "bc17d5c36c45dfba60d51599cc910f0533f7a600d983e433000c445d261a204f" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
