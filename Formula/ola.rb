class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.6/ola-0.10.6.tar.gz"
  sha256 "26a8302b5134c370541e59eabff0145dcf7127cda761890df10aa80dfe223af0"

  bottle do
    sha256 "9144c2e40e6ae25bcee43ba61a2097158a805a78e4ea24cdef3657bf4a7d4b34" => :high_sierra
    sha256 "73750ce1129ba0be3c94fd0e98834b1166fe746d3de7c3ae21a548e99659c50d" => :sierra
    sha256 "2e1711ae0bcd168816015439de578751a1edfdf032df1be17dfc170f0364bdf5" => :el_capitan
    sha256 "3ac33da0156083da563b70ce0157ff456ec557ace574ed45f7c5c06c1757eb7f" => :yosemite
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
