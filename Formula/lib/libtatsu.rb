class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.1.0/libtatsu-1.1.0.tar.bz2"
  sha256 "96c8abd97552a4a0c487c701aba9a65d590c338dd331058ffb38304290b696c7"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/libimobiledevice/libtatsu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c1bb7119bc08c23940a1eb05055824915eee5e09f14554722e67750f6b8a8552"
    sha256 cellar: :any, arm64_tahoe:       "f672af789246ca901b2feb021d27fb2d3e04c7b53a7f6170797d2fe3eb087e52"
    sha256 cellar: :any, arm64_sequoia:     "913371367c79a4288583b15267122b9160e4ef444d6a944b0eaf96758850500a"
    sha256 cellar: :any, arm64_linux:       "8bbd19a01ade741b4d5538812add677315675ae24f5423eeeae9824064dee461"
    sha256 cellar: :any, x86_64_linux:      "aeefa1286b99cc1a205bcef00fdd26f60de3b0169d7c31d6b6fbd3e02957935d"
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
