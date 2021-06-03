class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.29.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.29.tar.gz"
  sha256 "641676fc2f25f660ae32da7d04714ae4b5ec22833a6670ad2e75c7f6b5f86c70"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28f0da8bedbd629658464e66be36fd569ed845e79d847d48f1d17e257dc5cbfd"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b156537deed820ee5817b958b3f07c3a790ce4b982b585593abbd88aa13215"
    sha256 cellar: :any_skip_relocation, catalina:      "b5df224b8da7125f2e70caadee0a9a3352f84630e1d55136a968706f9df8ef88"
    sha256 cellar: :any_skip_relocation, mojave:        "3ed5535b6c11e9abca58004348499df0f692ce86e2802e15e677474852d128ca"
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
