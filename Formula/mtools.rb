class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.40.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.40.tar.gz"
  sha256 "b17ab808a7c08634d467756444d4f1cc63bb0ca66bf5807cd68f0d29b612e10f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc3aaad3c58d608d21e8e925e832b39fdcbce07475bb536e2d30557375501b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "754f600ec9872412c98d3d099a7603d28f54b332534ce200ddd05b2e475c6cd5"
    sha256 cellar: :any_skip_relocation, monterey:       "21fa9631936ed6f25b3cf398082d121c5efabdf6bc994d9736e819b26feca0af"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb289122815e8a1b6f73976416a621bd7186dc2b3dab46c7846e9459a113930"
    sha256 cellar: :any_skip_relocation, catalina:       "6dacc5b3844344b8aadfac199fe30fdf97d7cee502ca3ddf88718e45f111dc1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806c5a982aac57c129043fb9860438a3f26cf9a5e898db710555d7d269cd9bfc"
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
