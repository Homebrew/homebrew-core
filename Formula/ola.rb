class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.7/ola-0.10.7.tar.gz"
  sha256 "8a65242d95e0622a3553df498e0db323a13e99eeb1accc63a8a2ca8913ab31a0"
  revision 3
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    sha256 "c79b3dbe1896a6b78241401fbef0383d11259a67119d59cc6f8da4244e931c4c" => :catalina
    sha256 "7bfdb6292c1902de7307dc331948ea6de67e54ff38ebb0377dd75cebc4a8be94" => :mojave
    sha256 "ccbca5c750d2726eef78b4aa34a20c0c9f88f9b8a9f2840d6e6f12654de0e340" => :high_sierra
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
