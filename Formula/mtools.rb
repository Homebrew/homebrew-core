class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.26.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.26.tar.gz"
  sha256 "b1adb6973d52b3b70b16047e682f96ef1b669d6b16894c9056a55f407e71cd0f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7feca5219b2fa6f2581dc20b999198be1097061f7b77bea59f6b2ab047b6a12"
    sha256 cellar: :any_skip_relocation, big_sur:       "281355686b0b2bfdbdc3803337c0fed0e7ef5c5d9ac44aa229e05b44cb0179c5"
    sha256 cellar: :any_skip_relocation, catalina:      "f09aeaeda06fb25debe92e4681e81c78f2d1611664575048e06d7068ec25c168"
    sha256 cellar: :any_skip_relocation, mojave:        "cb7083728d1588a8b0b39ec229a73e935d89e82e285410f1e3fd2b5f0ff5016d"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  # 4.0.25 doesn't include the proper osx locale headers.
  patch :DATA

  def install
    args = %W[
      LIBS=-liconv
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end

__END__
diff --git a/sysincludes.h b/sysincludes.h
index 056218e..ba3677b 100644
--- a/sysincludes.h
+++ b/sysincludes.h
@@ -279,6 +279,8 @@ extern int errno;
 #include <pwd.h>
 #endif
 
+#include <xlocale.h>
+#include <strings.h>
 
 #ifdef HAVE_STRING_H
 # include <string.h>
