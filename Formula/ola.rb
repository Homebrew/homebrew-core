class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.6/ola-0.10.6.tar.gz"
  sha256 "26a8302b5134c370541e59eabff0145dcf7127cda761890df10aa80dfe223af0"

  bottle do
    sha256 "ada249b3e16aaee5610c9c4a2c438b158c1dcf36be684af62e4af6095984fe7b" => :high_sierra
    sha256 "06defbab5f678025a309989dc0c84aed8c2a315f880d9610263d2bdaab2d5c4c" => :sierra
    sha256 "9230a8fcc75bcc0c29c57dbd012909a2d7331823e70db1fc58462143c7350cf3" => :el_capitan
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-libftdi", "Install FTDI USB plugin for OLA."
  option "with-rdm-tests", "Install RDM Tests for OLA."
  deprecated_option "with-ftdi" => "with-libftdi"

  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "ossp-uuid"
  depends_on "protobuf@3.1"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "liblo" => :recommended
  depends_on "libusb" => :recommended
  depends_on "doxygen" => :optional
  depends_on "libftdi" => :optional
  depends_on "libftdi0" if build.with? "libftdi"

  resource "protobuf-c" do
    url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
    sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"
  end

  def install
    resource("protobuf-c").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{buildpath}/vendor/protobuf-c"
      system "make", "install"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"vendor/protobuf-c/lib/pkgconfig"

    protobuf_pth = Formula["protobuf@3.1"].opt_lib/"python2.7/site-packages/homebrew-protobuf.pth"
    (buildpath/".brew_home/Library/Python/2.7/lib/python/site-packages").install_symlink protobuf_pth

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-python-libs
      --disable-unittests
    ]

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
