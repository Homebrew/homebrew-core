class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "208e70aa0fe7dd9a39ebad95760c40d46f7d41be874d18b4d348ad8b9516e448"
    sha256 arm64_big_sur:  "cd431fcb424fe265a2b66e1a52fe3a3fade6b8d90d1afb2fbf9cd27ee20753a5"
    sha256 monterey:       "97168b89b1b78943d492f98e236d56c250b29fce5e19fce3299508420933d055"
    sha256 big_sur:        "d2733da8c041854c4417ac2f5d7ad28906f597ecfe9276cfad3f7cfe7b8e1a2b"
    sha256 catalina:       "4d8a96f00dbef138b8c679cbaa0a54d84cb5c97c24d108ca46b0639b19202b1e"
    sha256 x86_64_linux:   "aa15c84284c59702e6dc8d1b2b93ab06a6f4f3af12d94fb3ec3b8fd8185add62"
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

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
