class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 monterey: "91ed5a5cc4a18099e53d7a91a467f1d1dc2a579dd8eef181164ed67b70aeda1a"
    sha256 big_sur:  "7ffa9cad84a61a1dcdcd38aa70ae0db523a6d1c48db726b3c43627aeb4289191"
    sha256 catalina: "90ab760cd58aa7702e04bc58d2286821318d1adf72a64f36c75fb95924038c66"
    sha256 mojave:   "726e849cbe8f6cbd6ceaceacb0a356e1709b1613fb5efb55faba876852bf55d4"
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
  depends_on "python@3.9"

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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
