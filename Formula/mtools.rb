class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.39.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.39.tar.gz"
  sha256 "afa5eea196cef5a610a9b55d35b32d2887dc455ffc24e376d35b7a95ee3ec63e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9d664db4f472b0236aae604dda9441bc172111a89f6f2c686d2be09682c46d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abadcef15cb0fc52f3c0b0faa8bbaf21b2ca716260826928ce45804904b08760"
    sha256 cellar: :any_skip_relocation, monterey:       "b8899d048e48eea1ca6ac285ba5dec84116e5947e5a1f87ab489c12f4bab3781"
    sha256 cellar: :any_skip_relocation, big_sur:        "c096bd4035831f06d5b190443f05faf82ac295341c9dc73f061c2759d17899ba"
    sha256 cellar: :any_skip_relocation, catalina:       "df31c7fc862999819faa2967b72d7f4cbf77f6684526bb27f9f19ad56ce17550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f40dfeb90d7b38b01af7e66ec94414ced8b76e965f7c3a5620c8eb0392adfa75"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  # 4.0.25 doesn't include the proper osx locale headers.
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

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
