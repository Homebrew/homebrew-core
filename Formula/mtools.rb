class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.38.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.38.tar.gz"
  sha256 "0f89d7c1c948b94a1bac02734743f1189148fde8c3233833aeb52ef7fad530f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d352b9c8e8b73a9edf872160a1d66c8db95a39906663515c19841911a1a1459c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cdb00e80178db05baa29f038582d877ee2cf520106cd6fa40e37231ca59281f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b2d36cecaf5a14e3d0aa9279a8717b5c282e0a2751dc6a1faf6a0995e7281d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb20c7441d189658e48ee3aa63d7b24b578c3e4a01bd9613978a56933fed809e"
    sha256 cellar: :any_skip_relocation, catalina:       "7b0439da4380a0eb89e55fb8146cfc6381ab7acdd291ee247180b361f87de374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d94d7689040334732d7640cdaf37f7076caeb7bff7f78f6050aaba8ab55cf5"
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
