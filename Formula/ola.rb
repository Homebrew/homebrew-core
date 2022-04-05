class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "14de812197e5d732c3c57b9d1e1ccd3a4321cfa2403c33ca01ab68eb21e862f9"
    sha256 arm64_big_sur:  "e00c8546cb662cd64eaad5da196997c42e3b41dd58fbb281bac8784c3f1de3d1"
    sha256 monterey:       "9cbd30289e08d047669888a4b9a88e2016765454e855cd64463e6b278bc8308c"
    sha256 big_sur:        "37929b41d388d312df5fc8d99a67e86bb9c60148dad82d89a5432c3181a1c52e"
    sha256 catalina:       "7f83e608a0bd905f19f3b23853e8069dab0c1b96f8b88a64e7945d3e0438ba6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python@3.10"

  # remove in version 0.10.9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/add0354bf13253a4cc89e151438a630314df0efa/ola/protobuf3.diff"
    sha256 "e06ffef1610c3b09807212d113138dae8bdc7fc8400843c25c396fa486594ebf"
  end

  def install
    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
      --with-python_prefix=#{prefix}
      --with-python_exec_prefix=#{prefix}
    ]

    ENV["PYTHON"] = "python3"
    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_state", "-h"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
