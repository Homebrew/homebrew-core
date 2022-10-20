class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 6
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "da5cec4bdcc4e8fe6c322aaa77dbf9a24cf180fa3b72f57731a9ea7e1c5400fa"
    sha256 arm64_big_sur:  "02dda582adcdc9a76e093c98c40988892a280b875fd63ec00288cdaf5328ff7a"
    sha256 monterey:       "faea2e6dc970007ac903bc7bf10a847d1ffb55924e6040bd5e18da591411ac71"
    sha256 big_sur:        "873616e87caad74f8479ce3aa6dfb9d1dff865f616a097a6fd7992770f98e5b7"
    sha256 catalina:       "bdd790d4f5fed6db1c3e3ec65aac6f542737909e65e1cd6e90e9b33e56db51fe"
    sha256 x86_64_linux:   "f222379485424174bb5e2cb0341e395fa8d7fada09efb9f2b0fc33b090ae8b6b"
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

  def python3
    "python3.10"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

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

    ENV["PYTHON"] = python3
    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
