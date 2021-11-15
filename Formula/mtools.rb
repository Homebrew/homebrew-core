class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.35.tar.gz"
  sha256 "27af3ebb1b5c6c74ca0b8276bf21b70c3fb497dd8eb1b605d74df7a761aedef5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a264c24e09d226adf59bb9e917f70bceb2c1f0bfb409aeb85f72bf67bf9c843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18cddaa9135b9523b2bf852c66cebf108a52c665faabb4eceb1dc8038f7b3265"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0c23f6f8ab679b2a842d98826f58412e529b0f33404ec94e4190dfbab3aa0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b327d09dd012e22085b77055ca713db9e2b0b054b58d2da0f446d977d4a7d17"
    sha256 cellar: :any_skip_relocation, catalina:       "82f3ac919cf59793834c72e525d8b76f0249401a78c6bdc16eb70ea394f1b798"
    sha256 cellar: :any_skip_relocation, mojave:         "eff0b4cc2fa5e3090634b2f25865593c240a654edeb0a0b21c628179ac8899d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ebb016b728650f785c08f42c9ae191bcd163c34b5aaed9dae3352a394e5d97"
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
