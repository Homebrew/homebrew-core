class Ideviceinstaller < Formula
  desc "Cross-platform library for communicating with iOS devices"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 4

  bottle do
    cellar :any
    sha256 "a09d4f1c04382e6cf8e0a148dcb4ba8fdd4ba03ce929d2120754fa6558dcd250" => :high_sierra
    sha256 "f4182b2f2c15ffa2aab4c0309dfdde0e2963ecf47b5d2f181b952b0df7f34518" => :sierra
    sha256 "d2430c6d94c98b2083d971fb28746c74eda0b44ef5e37ed1c4888ba6878b009e" => :el_capitan
    sha256 "dcc8ebee2bc878bc2e2bdd1fc4e66c9a60860b434aa1f2b570f52edc68b37915" => :yosemite
  end

  head do
    url "https://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
