class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.2/ola-0.10.2.tar.gz"
  sha256 "986e61874bc80db3b23cf201af2dafa39e3412cc50cddf1cd449c869110bfd27"
  revision 2

  bottle do
    sha256 "9228deb0971127ecf4ef9f1e137ae7b070476d1fd76935ab8beb5f2b66ebe0b3" => :el_capitan
    sha256 "8a46fc44380904cf6ac5da21171d3227ecb9ce852a566a36059498b9cc913c18" => :yosemite
    sha256 "7678f975c90df42335e74207e58aae445a75a113515fa505c5b6c142aef07831" => :mavericks
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
