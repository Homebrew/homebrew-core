class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/archive/0.10.3.tar.gz"
  sha256 "474db6752940cea6cd9493dcbeeb13429b5d29f4777973d08738cb5ef04c9dcd"
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    sha256 "164fd596606c68a6a826e030231f7b329c46954de1077f253fd6ebbd7218839b" => :sierra
    sha256 "51227df09255050dc92d773aa8274ffd26895ecf28c2f6c5207424f3b791e141" => :el_capitan
    sha256 "ce8e55b11b5988f652f606d96d06dca2f2b5f2fad76d09a45f9ff6d612abf4d1" => :yosemite
  end

  option :universal
  option "with-libftdi", "Install FTDI USB plugin for OLA."
  option "with-rdm-tests", "Install RDM Tests for OLA."
  deprecated_option "with-ftdi" => "with-libftdi"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "libmicrohttpd"
  depends_on "ossp-uuid"
  depends_on "protobuf-c"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "liblo" => :recommended
  depends_on "libusb" => :recommended
  depends_on "doxygen" => :optional
  depends_on "libftdi" => :optional
  depends_on "libftdi0" if build.with? "libftdi"

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-python-libs
    ]

    args << "--enable-rdm-tests" if build.with? "rdm-tests"
    args << "--enable-doxygen-man" if build.with? "doxygen"

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
