class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.2/ola-0.10.2.tar.gz"
  sha256 "986e61874bc80db3b23cf201af2dafa39e3412cc50cddf1cd449c869110bfd27"

  bottle do
    sha256 "37dabc62d0ed531c06bdf4bc153858d0a8f30f895b4f3765d6f2b9a69b03e840" => :el_capitan
    sha256 "02e54e500f150f1319e293e1a4ad8e5069f4d11a09e25bf6934a5f5cc6acc8cf" => :yosemite
    sha256 "999880d987365682c1e90cb81e0def7139e244aa573bc327cf038fe920596705" => :mavericks
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
