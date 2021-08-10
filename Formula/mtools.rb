class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.35.tar.gz"
  sha256 "27af3ebb1b5c6c74ca0b8276bf21b70c3fb497dd8eb1b605d74df7a761aedef5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4732fac3050d08cb7645158f7a695c6b1131863797f9522ef24816873e6ee6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b788824e4d9a861db566caae41dc0d7290232db79f434ca63c871bdd637913b"
    sha256 cellar: :any_skip_relocation, catalina:      "bbf3f0335de4eb86bc042691965bd8a494cbb828701c760a620d2e3b1c945900"
    sha256 cellar: :any_skip_relocation, mojave:        "ff61db59edf8286c99b002480db699fcdce81ae5f3570470fe59dbed24847ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29c75e28e06f1ccac38e687e1b7885544e105bc3e7f674a87c92d241771b9ca3"
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
