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

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "06c136368fdf19cd9b6a627930406bd96d06c82a60beef63d4f702000eda8e6c"
    sha256 cellar: :any,                 arm64_sequoia: "161bee9030b1f4d9170c831ba10fb682f89d54be2d206f895d78b73ec08aa7b9"
    sha256 cellar: :any,                 arm64_sonoma:  "d23b54efd3605e0e59fbb7ddbec4d17d990a99772af413f6643679064e346dde"
    sha256 cellar: :any,                 sonoma:        "d9581caceab52be6bdd840f98a0f6fcc30349ce80dd3a1dca3fc88d580b8b9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6964cc72ed89391d86c565cdcef99c45c753aa6b3196826da4ebe859280a9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b07b5a9ec6f887b51a0c212a363e1943a4cb1c0059b23261ae9ea2649f274ab"
  end

  deprecate! date: "2026-01-05", because: "uses deprecated libxdiff"

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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      ENV["HB_WITH_ZLIB"] = Formula["zlib-ng-compat"].opt_include
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
