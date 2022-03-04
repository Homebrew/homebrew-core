class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.38.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.38.tar.gz"
  sha256 "0f89d7c1c948b94a1bac02734743f1189148fde8c3233833aeb52ef7fad530f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0632252f8431e74b75b3d26883ba6e7171371a51342d88d2099858cdda8bc7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faf9901a1c48b53f77fa23051d87d99667724b083641e01061240e32576fcf33"
    sha256 cellar: :any_skip_relocation, monterey:       "96aecf3a1109be9c7e21f10689eb1a3f37227c18ba090bda97b69646dc1d98c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5c9433a920db9c7fd6b35655a80f96557ddf45f160acef763c5ccdaa212cd8"
    sha256 cellar: :any_skip_relocation, catalina:       "d007f7e298b10a1c7199e4b89582ab29a4e08355d43201311146dc8a1602714e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3d5ac55e5ecfec2a1993383b175f02d0de73ed0687f54eacc076ed2765844e"
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
