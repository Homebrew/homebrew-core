class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.2/ola-0.10.2.tar.gz"
  sha256 "986e61874bc80db3b23cf201af2dafa39e3412cc50cddf1cd449c869110bfd27"
  revision 2

  bottle do
    sha256 "164fd596606c68a6a826e030231f7b329c46954de1077f253fd6ebbd7218839b" => :sierra
    sha256 "51227df09255050dc92d773aa8274ffd26895ecf28c2f6c5207424f3b791e141" => :el_capitan
    sha256 "ce8e55b11b5988f652f606d96d06dca2f2b5f2fad76d09a45f9ff6d612abf4d1" => :yosemite
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-ftdi", "Install FTDI USB plugin for OLA."
  # RDM tests require protobuf-c --with-python to work
  option "with-rdm-tests", "Install RDM Tests for OLA."

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "ossp-uuid"
  depends_on "libusb" => :recommended
  depends_on "liblo" => :recommended
  depends_on "doxygen" => :optional

  if build.with? "ftdi"
    depends_on "libftdi"
    depends_on "libftdi0"
  end

  if build.with? "rdm-tests"
    depends_on :python if MacOS.version <= :snow_leopard
  else
    depends_on :python => :optional
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-python-libs" if build.with? "python"
    args << "--enable-rdm-tests" if build.with? "rdm-tests"
    args << "--enable-doxygen-man" if build.with? "doxygen"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
