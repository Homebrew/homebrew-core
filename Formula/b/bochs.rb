class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/3.0/bochs-3.0.tar.gz"
  sha256 "cb6f542b51f35a2cc9206b2a980db5602b7cd1b7cf2e4ed4f116acd5507781aa"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "b358cdb2e679f040071c7da9ccf6cad7d82f144d47adb65fc2bafc2fb1ed01c5"
    sha256 arm64_sequoia: "771309e968819d820ed0b538ed7a6c2365182b6e939e8de95c5a64265dcd0f28"
    sha256 arm64_sonoma:  "7fc4fd6a6ead512d3b9fb13964529682f17356ffe7e10a7692e6c42940d48f21"
    sha256 arm64_ventura: "9c9acd2ad176ca2cde5e04bf1041e62649cf32d3ff11a0e272fc0394092c82f4"
    sha256 sonoma:        "308e5183b90eca43959de4064497c3d76e279c9b7849a7c8a68578fe8e0ec838"
    sha256 ventura:       "1b8557fd5e2ba1133050f72867b8254401003ac7064d81788046025446367efc"
    sha256 arm64_linux:   "c90bc3f05f5534d123939bc79e2afa947fc469e9841a2f6339ac8a5ce613ce4c"
    sha256 x86_64_linux:  "ad4f70d9e3cb7e9139e9542f351869f3e2175903c7bead372d988bb31ea784aa"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "sdl2"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  # include `<libgen.h>` for macos build, upstream bug report, https://sourceforge.net/p/bochs/bugs/1466/
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-evex
      --enable-cdrom
      --enable-clgd54xx
      --enable-cpu-level=6
      --enable-debugger
      --enable-debugger-gui
      --enable-disasm
      --enable-fpu
      --enable-iodebug
      --enable-large-ramfile
      --enable-logging
      --enable-long-phy-address
      --enable-pci
      --enable-plugins
      --enable-readline
      --enable-show-ips
      --enable-usb
      --enable-vmx=2
      --enable-x86-64
      --with-nogui
      --with-sdl2
      --with-term
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<~EOS
      panic: action=fatal
      error: action=report
      info: action=ignore
      debug: action=ignore
      display_library: nogui
    EOS

    expected = <<~EOS
      Bochs is exiting with the following message:
      [BIOS  ] No bootable device.
    EOS

    command = "#{bin}/bochs -qf bochsrc.txt"

    # When the debugger is enabled, bochs will stop on a breakpoint early
    # during boot. We can pass in a command file to continue when it is hit.
    (testpath/"debugger.txt").write("c\n")
    command << " -rc debugger.txt"

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end

__END__
diff --git a/gui/keymap.cc b/gui/keymap.cc
index 3426b6b..7bf76d8 100644
--- a/gui/keymap.cc
+++ b/gui/keymap.cc
@@ -30,6 +30,10 @@
 #include "gui.h"
 #include "keymap.h"

+#if defined(__APPLE__)
+#include <libgen.h>
+#endif
+
 // Table of bochs "BX_KEY_*" symbols
 // the table must be in BX_KEY_* order
 const char *bx_key_symbol[BX_KEY_NBKEYS] = {
