class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.1.0/libtatsu-1.1.0.tar.bz2"
  sha256 "96c8abd97552a4a0c487c701aba9a65d590c338dd331058ffb38304290b696c7"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/libimobiledevice/libtatsu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "04de393a1757ad619de94bc636091920ecd18c4dcc5a7b59739e1b027c751e2d"
    sha256 cellar: :any, arm64_tahoe:       "c2c9378a90a8d95d160a1d8c044719a12ec11f87608cce3ad7f94de50e27efb8"
    sha256 cellar: :any, arm64_sequoia:     "c6220731852f43f37d34164579d16e139192387249b1751a4abf1cbb47ddfcda"
    sha256 cellar: :any, arm64_linux:       "d7ec4206f131fe610a0ba60afe544762492b89ac24a9f1382e03d6dc4e75bb66"
    sha256 cellar: :any, x86_64_linux:      "53039b809871d21fa1185003922f6337c134280a466cb22b4bd6e748400d0752"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libtatsu/tss.h"

      int main(int argc, char* argv[]) {
        tss_set_debug_level(0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
