class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.7.0.1.tar.gz"
  sha256 "d7c4b400f506bee1b0f0baecb9285bb7230588f0afa050bb898d5d48454b1632"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "371a2574fe88a3251f570168f46edecd1e7754a0931baf5d412d401bb242fefc"
    sha256 arm64_monterey: "681beef5015bf019828a043715db83e4dd60520f16a81dc407cd87b02b8cceb6"
    sha256 arm64_big_sur:  "d19ad9cb90362d9ed47428bcb9a49e0397f67bcc4bc71f5a996edba314dd987d"
    sha256 ventura:        "c3fc9261295fdd76cce2d51c5761f6b4d2937688b30ac82a0e8a3c75b9d0d3f0"
    sha256 monterey:       "a6de554ea6baa063a23f8324900411222eb5aa09c8988f2f12ffccdccc6a183a"
    sha256 big_sur:        "3583fedeaa83d5c0a82cf51aa225ee3798db0f1779a094c466011fabcfbcc39f"
    sha256 catalina:       "fa4cc1227af8aabfacefbe89d9e1079c6510aa29a2ca5626c5557f6d1f73e0a7"
    sha256 x86_64_linux:   "d71d0d8766ea2346659017b6ab6d232d0473a9ffc280c2464fa7102fdda2acce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
