class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/3.1/bochs-3.1.tar.gz"
  sha256 "14aaf78dbe1337987923fffc4e7a962ae56abcf9a87474ace39e593f9f84ee84"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "e21dd77f31eea91a45ec504646e5d8c5ae0f3ded2ed4f6744cec702808c15abe"
    sha256 arm64_sequoia: "031d39f54f112336f2d3d9abf50787df41e1c082c93fb84ff95572372c50d198"
    sha256 arm64_sonoma:  "ecc97b5964e9955d9d2acb7a20704491bee4080354d9b464090c29b28d41aacf"
    sha256 sonoma:        "7c8ea92a5673543fb88c54dcc4c8daeb2905b34c45e715d2dee1aff18e52d95a"
    sha256 arm64_linux:   "45120b649ca29db55f4a4c53d4778b7a4af822d3ade89978aa601cc697e65b77"
    sha256 x86_64_linux:  "eeaf0eea56cd550960493c2a1f51a67265eb9cd7e873509238bdc01ad7866848"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "sdl2-compat"

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
