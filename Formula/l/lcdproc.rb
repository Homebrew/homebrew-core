class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "https://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "c2685b2448e1356097e6eac9c25749bb2ff46414f72c2724c23c40cc346ba1f9"
    sha256 arm64_sequoia: "3eca8d7c437762dd23e0781803c8c4c9c8b96372254c260f94c2b1c16b0f569a"
    sha256 arm64_sonoma:  "8e4bac85060f2e07bf2a15c082b185b5a7d0ac69231602082691ee48142f09df"
    sha256 sonoma:        "16efc1c9a35bf0563aa2c66a8f653c56e1ef4694956533c31acc722af6834f86"
    sha256 ventura:       "ff2675dfa714a9de7e8d5a9f40c214cf5547c85c402337e7376a54631f43020a"
    sha256 monterey:      "90bb0544163a3966aac4de0dffaff4a9cc59cb05e08c314a28829fcf8df8e38b"
    sha256 big_sur:       "937564e19f5e45fd49b02e83577a4e217abf89ca3884958b3f9e80b2132fa8df"
    sha256 catalina:      "8899d5c5afebdf222f014f383e009071bda3f075a08e5f0d729a81f99c9c8086"
    sha256 arm64_linux:   "31e9cdd685bcf637f916a0f897c8bf9da80b89da8440b66a21fead876ed3f9c2"
    sha256 x86_64_linux:  "d869dec7aa2e03b2c6bc21a281ac56537d5a596e0a87442fc79fda035f000282"
  end

  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat" # Remove when all drivers migrated https://github.com/lcdproc/lcdproc/issues/13

  uses_from_macos "ncurses"

  # Backport support for non-x86_64 platforms from
  # https://github.com/lcdproc/lcdproc/commit/695aa0f76173a03295a6d897d7260a09951931bc
  patch :DATA

  def install
    ENV.append_to_cflags "-fcommon" if ENV.compiler.to_s.start_with?("gcc")

    system "./configure", "--disable-silent-rules",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end

__END__
diff --git a/server/drivers/port.h b/server/drivers/port.h
index c584cd4e774c3e081f8b84017acaa7330837421b..f80a09d79c15c46cb8c93d0710038643c5b0ea6a 100644
--- a/server/drivers/port.h
+++ b/server/drivers/port.h
@@ -94,7 +94,7 @@ static inline int port_deny_multiple(unsigned short port, unsigned short count);
 /*  ---------------------------- Linux ------------------------------------ */
 /*  Use ioperm, inb and outb in <sys/io.h> (Linux) */
 /*  And iopl for higher addresses of PCI LPT cards */
-#if defined HAVE_IOPERM
+#if defined HAVE_IOPERM && (defined(__x86__) || defined(__x86_64__))
 
 /* Glibc2 and Glibc1 */
 # ifdef HAVE_SYS_IO_H
@@ -333,7 +333,7 @@ static inline int port_deny_multiple (unsigned short port, unsigned short count)
 	return i386_set_ioperm(port, count, 0);
 }
 
-#else
+#elif (defined(__x86__) || defined(__x86_64__))
 
 /*  ------------------------- Everything else ----------------------------- */
 /*  Last chance! Use /dev/io and i386 ASM code (BSD4.3 ?) */
@@ -384,6 +384,10 @@ static inline int port_deny_multiple (unsigned short port, unsigned short count)
 	return 0;
 }
 
+#else
+
+#error No low level lpt port access supported on this platform.
+
 #endif
 
 #endif /* PORT_H */
diff --git a/server/drivers/serialVFD_io.c b/server/drivers/serialVFD_io.c
index 8dbc3794889ec080e3053d457b10ac451a48dd9c..e20c0ea5ee1a03c970e6e2123718fc8f1f8d59bc 100644
--- a/server/drivers/serialVFD_io.c
+++ b/server/drivers/serialVFD_io.c
@@ -41,8 +41,14 @@
 
 #include "lcd.h"
 #include "shared/report.h"
+
+#ifdef HAVE_PCSTYLE_LPT_CONTROL
+
 #include "lpt-port.h"
 #include "port.h"
+
+#endif
+
 #include "serialVFD_io.h"
 #include "serialVFD.h"
 
