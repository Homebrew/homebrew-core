class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"
  revision 1

  bottle do
    cellar :any
    sha256 "49c87edc709e6dae34b1e74425c3c7229c4f0b39cc840f57d874d31347d681f5" => :sierra
    sha256 "a30be565e1922ee56486c4b59d5aab28d6f90c67f2eb978ac697dbcbb749a2a1" => :el_capitan
    sha256 "8e5f3022963bbbd8f8fce2e976a39c0432c8d6631886f28fe869165510e3ebca" => :yosemite
  end

  head do
    url "https://git.libimobiledevice.org/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
