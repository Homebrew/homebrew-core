class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.7/ola-0.10.7.tar.gz"
  sha256 "8a65242d95e0622a3553df498e0db323a13e99eeb1accc63a8a2ca8913ab31a0"
  license "GPL-2.0"
  revision 5
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    rebuild 1
    sha256 "13a256a0bf648fd37be6190655af18b3d68d08cf6ccdc739870f2f89d6b5a11b" => :catalina
    sha256 "3e18bbda8d9093ad9204067849de41c288d36154a4e3f5d71138254866a2cecb" => :mojave
    sha256 "ca923883d08d515008ed578e1ebb6fa0c691c7e7f2c251958084bd2005185e86" => :high_sierra
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
  depends_on "python@3.9"

  # remove in version 0.11
  patch do
    url "https://raw.githubusercontent.com/macports/macports-ports/89b697d200c7112839e8f2472cd2ff8dfa6509de/net/ola/files/patch-protobuf3.diff"
    sha256 "bbbcb5952b0bdcd01083cef92b72a747d3adbe7ca9e50d865a0c69ae31a8fb4a"
  end

  # Fix compatibility with libmicrohttpd
  # Remove in next version
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcd2679/ola/libmicrohttpd.diff"
    sha256 "752f46b6cfe2d9c278c3fd0e68ff753479ca4bba34a3b41f82d523daafde8d08"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    protobuf_pth = Formula["protobuf@3.6"].opt_lib/"python#{xy}/site-packages/homebrew-protobuf.pth"
    (buildpath/".brew_home/Library/Python/#{xy}/lib/python/site-packages").install_symlink protobuf_pth

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
    ]

    ENV["PYTHON"] = Formula["python@3.9"].bin/"python3"
    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
