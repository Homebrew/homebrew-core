class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.7/ola-0.10.7.tar.gz"
  sha256 "8a65242d95e0622a3553df498e0db323a13e99eeb1accc63a8a2ca8913ab31a0"

  bottle do
    sha256 "ee18bf52b5f3547051fc3baa74275988e4e98c6c83ab9ddd57a7d001e628f54a" => :mojave
    sha256 "b3d17f68ff88ef2f66687b05ec63c60823ce10c89e28825572b440d91b93c760" => :high_sierra
    sha256 "71ec88044cdf0fee7399506b5d383b7eef0ad77ebc826cf45adf5944cad5a0df" => :sierra
    sha256 "fa4b68d22686172fa2f618974eca5e03b57947b15d9ea069d253364f71aa354f" => :el_capitan
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
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "ossp-uuid"
  depends_on "protobuf@3.1"
  depends_on "python@2"
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

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
