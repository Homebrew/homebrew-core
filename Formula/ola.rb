class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.7/ola-0.10.7.tar.gz"
  sha256 "8a65242d95e0622a3553df498e0db323a13e99eeb1accc63a8a2ca8913ab31a0"
  revision 3
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    sha256 "cfd140e18776665bea8ff51d04f33db99d3925433d6c51a3dde8684bb9b408a9" => :catalina
    sha256 "9b6ba39db2eac356f2811ad76f3d6dae0e7b9d0f22a0dbc919fa0e4fda9cd639" => :mojave
    sha256 "949692cfbcf0408d27e523d858b38a778e812994f28f7790f09b1ceb6ec9187a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf@3.6"
  depends_on "python"

  # remove in version 0.11
  patch do
    url "https://raw.githubusercontent.com/macports/macports-ports/89b697d200c7112839e8f2472cd2ff8dfa6509de/net/ola/files/patch-protobuf3.diff"
    sha256 "bbbcb5952b0bdcd01083cef92b72a747d3adbe7ca9e50d865a0c69ae31a8fb4a"
  end

  def install
    protobuf_pth = Formula["protobuf@3.6"].opt_lib/"python3.7/site-packages/homebrew-protobuf.pth"
    (buildpath/".brew_home/Library/Python/3.7/lib/python/site-packages").install_symlink protobuf_pth

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
    ]

    ENV["PYTHON"] = "python3"
    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
