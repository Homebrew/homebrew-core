class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.37.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.37.tar.gz"
  sha256 "426dc3d15017aae8daf68c9119c0f5f2eafb30deb4a4b417d7d763c4ab728c7b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d0964d50ce67f013ec9a4769b59406c30dda038e690461bd6451aa98b61f0cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d58a40169272731e1d5e9fa070f70f641d8234ed4c55729ce7ec56d8f33cc980"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe539989b5ddeae63ac7213b13d90368b065097a64ef114f15c1f346ccbe684"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7de6f4b2cecca7f5b6747191e09aefae2301f089e0bb2f6a40eeab539c91ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "4accfc58c6179355a5b8a0d46e58b691763e6063b6f0362960b2902d88bcbca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d2adf102b481bdb99ae4e16a124dc622fa8469dd1a5330bf094d5f0ed1a54f4"
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
