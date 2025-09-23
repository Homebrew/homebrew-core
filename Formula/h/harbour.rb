class Harbour < Formula
  desc "Portable, xBase-compatible programming language and environment"
  homepage "https://harbour.github.io"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/harbour/core.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/harbour-project/source/3.0.0/harbour-3.0.0.tar.bz2"
    sha256 "4e99c0c96c681b40c7e586be18523e33db24baea68eb4e394989a3b7a6b5eaad"

    # Missing a header that was deprecated by libcurl @ version 7.12.0 and
    # deleted sometime after Harbour 3.0.0 release.
    # Also backport upstream changes in src/rtl/arc4.c for glibc 2.30+.
    patch :DATA
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/harbour[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "935cc21388de6b60757cfc22f1e3692bf9dc0fdd22fab8caf5090325e420aaac"
    sha256 cellar: :any,                 arm64_sequoia:  "c391f2098164917feb69d3e4820c3c7495dbb84689c5fe2b5dcf5f0d5940d82c"
    sha256 cellar: :any,                 arm64_sonoma:   "7e80473b90f18a1d0825801e625bb117f69551e6d04f11fd65b113b2ab8e53cb"
    sha256 cellar: :any,                 arm64_ventura:  "ad3d5b72015a0fb027952c207b4637adb47a3535e8492cb3553e687720b20b59"
    sha256 cellar: :any,                 arm64_monterey: "b767ebd7a0e600631d6d61ce3a8bbd907f3f8fd305270ac85053684ecce5ebea"
    sha256 cellar: :any,                 sonoma:         "cc37a07184ba91033dc4b4e824a302f9ef54abbee7026fbd0cda30f2d2cbeb57"
    sha256 cellar: :any,                 ventura:        "3f888b135d92845905b0926aef1623e5c4bcc72b4c71cc4d6f45554c5200f78b"
    sha256 cellar: :any,                 monterey:       "407f06fad0eac6ca57c858185ebe6e77bb4dcd7740c5b91a6c0e7524d72642c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "798cc4aee29d60fb9fe930c7b22f691de6e5f0b90ac997f42d41d1c1d589baf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2087353cafad551175524915a162da8520c6401686c1d4d70414553fbc2d1f1b"
  end

  depends_on "jpeg-turbo"
  depends_on "libharu"
  depends_on "libpng"
  depends_on "libxdiff"
  depends_on "minizip"
  depends_on "pcre"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    # Delete files that cause vendored libraries for minizip and expat to be built.
    rm "contrib/hbmzip/3rd/minizip/minizip.hbp"
    rm "contrib/hbexpat/3rd/expat/expat.hbp"

    # 1. Fix flat namespace usage.
    #    Upstreamed here: https://github.com/harbour/core/pull/263.
    # 2. Avoid using libtool due to `ld: unknown options: -force_cpusubtype_ALL`
    #    https://github.com/Homebrew/homebrew-core/pull/242642#issuecomment-3292186403
    inreplace "config/darwin/clang.mk" do |s|
      s.gsub! "DY := $(AR)", "DY := cc"
      s.gsub!(/^DFLAGS \+= .* \$\(LIBPATHS\)$/,
              "DFLAGS += -shared -Wl,-undefined,dynamic_lookup $(LIBPATHS)")
    end

    # The following optional dependencies are not being used at this time:
    # allegro, cairo, cups, freeimage, gd, ghostscript, libmagic, mysql, postgresql, qt@5, unixodbc
    # openssl can not included because the hbssl extension does not support OpenSSL 1.1.

    # The below dependencies are included because they will be built as vendored libraries by default.
    # The vendored version of liblzf is used instead of the Homebrew one because the Homebrew version
    # is missing header files and the extension will not build
    # The vendored version of libmxml is used because it needs config.h, which is not included in
    # the Homebrew version of libmxml.
    # The vendored version of minilzo is used because the Homebrew version of lzo does not include minilzo.
    ENV["HB_INSTALL_PREFIX"] = prefix
    ENV["HB_WITH_X11"] = "no"
    ENV["HB_WITH_JPEG"] = Formula["jpeg-turbo"].opt_include
    ENV["HB_WITH_LIBHARU"] = Formula["libharu"].opt_include
    ENV["HB_WITH_MINIZIP"] = Formula["minizip"].opt_include/"minizip"
    ENV["HB_WITH_PCRE"] = Formula["pcre"].opt_include
    ENV["HB_WITH_PNG"] = Formula["libpng"].opt_include
    ENV["HB_WITH_XDIFF"] = Formula["libxdiff"].opt_include

    if OS.mac?
      ENV["HB_COMPILER"] = ENV.cc
      ENV["HB_USER_DFLAGS"] = "-L#{MacOS.sdk_path}/usr/lib"
      ENV.append "HB_USER_DFLAGS", "-macosx_version_min #{MacOS.version}.0" if Hardware::CPU.arm?
      ENV["HB_WITH_BZIP2"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_CURL"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_CURSES"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_EXPAT"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_SQLITE3"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_ZLIB"] = MacOS.sdk_path/"usr/include"
    else
      ENV["HB_WITH_BZIP2"] = Formula["bzip2"].opt_include
      ENV["HB_WITH_CURL"] = Formula["curl"].opt_include
      ENV["HB_WITH_CURSES"] = Formula["ncurses"].opt_include
      ENV["HB_WITH_EXPAT"] = Formula["expat"].opt_include
      ENV["HB_WITH_SQLITE3"] = Formula["sqlite"].opt_include
      ENV["HB_WITH_ZLIB"] = Formula["zlib"].opt_include
    end

    ENV.deparallelize

    system "make", "install"

    rm Dir[bin/"hbmk2.*.hbl"]
    rm bin/"contrib.hbr" if build.head?
    rm bin/"harbour.ucf" if build.head?
  end

  test do
    (testpath/"hello.prg").write <<~EOS
      procedure Main()
         OutStd( ;
            "Hello, world!" + hb_eol() + ;
            OS() + hb_eol() + ;
            Version() + hb_eol() )
         return
    EOS

    assert_match "Hello, world!", shell_output("#{bin}/hbmk2 hello.prg -run")
  end
end

__END__
diff --git a/contrib/hbcurl/core.c b/contrib/hbcurl/core.c
index 00caaa8..53618ed 100644
--- a/contrib/hbcurl/core.c
+++ b/contrib/hbcurl/core.c
@@ -53,8 +53,12 @@
  */

 #include <curl/curl.h>
-#include <curl/types.h>
-#include <curl/easy.h>
+#if LIBCURL_VERSION_NUM < 0x070A03
+#  include <curl/easy.h>
+#endif
+#if LIBCURL_VERSION_NUM < 0x070C00
+#  include <curl/types.h>
+#endif

 #include "hbapi.h"
 #include "hbapiitm.h"
diff --git a/src/rtl/arc4.c b/src/rtl/arc4.c
index 8a3527c..69b4e8b 100644
--- a/src/rtl/arc4.c
+++ b/src/rtl/arc4.c
@@ -54,7 +54,15 @@
 /* XXX: Check and possibly extend this to other Unix-like platforms */
 #if ( defined( HB_OS_BSD ) && ! defined( HB_OS_DARWIN ) ) || \
     ( defined( HB_OS_LINUX ) && ! defined ( HB_OS_ANDROID ) && ! defined ( __WATCOMC__ ) )
-#  define HAVE_SYS_SYSCTL_H
+    /*
+     * sysctl() on Linux has fallen into depreciation. Not available in current
+     * runtime C libraries, like musl and glibc >= 2.30.
+     */
+#  if ( ! defined( HB_OS_LINUX ) || \
+      ( ( defined( __GLIBC__ ) && ! ( ( __GLIBC__ > 2 ) || ( ( __GLIBC__ == 2 ) && ( __GLIBC_MINOR__ >= 30 ) ) ) ) ) || \
+      defined( __UCLIBC__ ) )
+#     define HAVE_SYS_SYSCTL_H
+#  endif
 #  define HAVE_DECL_CTL_KERN
 #  define HAVE_DECL_KERN_RANDOM
 #  if defined( HB_OS_LINUX )
