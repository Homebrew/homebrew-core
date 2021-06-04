class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.29.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.29.tar.gz"
  sha256 "641676fc2f25f660ae32da7d04714ae4b5ec22833a6670ad2e75c7f6b5f86c70"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4729d29ebbee602d9d2e08d3f3c2a3c8f5d6046d9f5022aea6e6dc31ae5ebdac"
    sha256 cellar: :any_skip_relocation, big_sur:       "f800c846a3d0c54bf973d5ea9705923b112e0cafbea95b8702b6191a735ad91e"
    sha256 cellar: :any_skip_relocation, catalina:      "c81917c79a0551c2edebea61112fbb0a1161066392366e16e9881c28873f86c3"
    sha256 cellar: :any_skip_relocation, mojave:        "b0c2c049dedeac135038a45304497086356eb109347018e5a0a0d0bc932fd81d"
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
