class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.7/ola-0.10.7.tar.gz"
  sha256 "8a65242d95e0622a3553df498e0db323a13e99eeb1accc63a8a2ca8913ab31a0"

  bottle do
    rebuild 1
    sha256 "a8bd1491e4534a97ae5d31be6a25dda95d5513696e23931846f70d823f32d06b" => :mojave
    sha256 "0d2cd27e4c0de1896ff237a3334d1a69efb396b1fc9e2ce36f4ecaa46b8fbf00" => :high_sierra
    sha256 "516b9937272a72a646b2eefb6457bf2eadc125e75140ed6632d2e59fc1677c1c" => :sierra
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "ossp-uuid"
  depends_on "protobuf@3.1"
  depends_on "python@2"

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
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
