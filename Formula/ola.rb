class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/archive/0.10.3.tar.gz"
  sha256 "474db6752940cea6cd9493dcbeeb13429b5d29f4777973d08738cb5ef04c9dcd"
  revision 1
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    sha256 "414efbcd331ca04b7c56e5c555cbe929adcd717e8f497b023215c12d7826ad12" => :sierra
    sha256 "028eb3416ceb0418ad0092318a8a47ca704aaeb190173a8beafe6fe58963beaa" => :el_capitan
    sha256 "fd4409d7fa44587e429d240c38f546ccf5a1986d9d1a0a323182148a97547c1e" => :yosemite
  end

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
  depends_on "protobuf@3.1"
  depends_on :python if MacOS.version <= :snow_leopard
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
