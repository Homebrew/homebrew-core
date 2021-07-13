class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.31.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.31.tar.gz"
  sha256 "37d0a97717625453e9a88b51c41233f00f2757a51d7eeffe8a0841784bb6f3d6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4a2c598ecc8fa73fc8b3aaa9bd56b91c3137c1cfb431ce9c795ee69d9cab3ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "a38b210941937a9424d92096af7fa3470b9664460ba19d17631675b88889c4e8"
    sha256 cellar: :any_skip_relocation, catalina:      "9561b64f4c3ca6d11fe5f13e7fa205a777dbecbb4c150b936dbb97eed15c9e8b"
    sha256 cellar: :any_skip_relocation, mojave:        "0178acec6b4cb1d206534712d0304de310d8887ef4733998387286f46137c16a"
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
    on_macos do
      args << "LIBS=-liconv"
    end

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
