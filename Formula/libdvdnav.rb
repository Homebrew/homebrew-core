class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.0/libdvdnav-6.1.0.tar.bz2"
  sha256 "f697b15ea9f75e9f36bdf6ec3726308169f154e2b1e99865d0bbe823720cee5b"
  revision 1

  bottle do
    cellar :any
    sha256 "96d4aad1cf2187167e10dc24325351820b69a878e68ca13a642fda429f25c387" => :catalina
    sha256 "30d529890adc40cd9050badced4da9bc5b1a9ff70b1ef301fa347f22795a8d27" => :mojave
    sha256 "4f626dcca020c7b478eda79ef151da02673fcf76f2c6a7eea3f68f7d4e40bbf8" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
