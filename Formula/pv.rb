class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.19.tar.bz2"
  sha256 "aa30823f072cb4953424b0f9b55497b9238cc8e9d47e246cd4ecbf1312f6e835"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bd7779d9b752efbe2630b20372d9cf4d59162ddd007ec03543b80f2101213e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ea237c542c6eded14c7cea0a1cdbfcbd7a08ee5eb3840f17074cf744ed9029e"
    sha256 cellar: :any_skip_relocation, catalina:      "497f6ce8e29bbf9e0327afede72168c33acfb1ccb6604767862accb98503e909"
    sha256 cellar: :any_skip_relocation, mojave:        "b2c882e0cd98de9b8db1ded95104239e890fe8e9b1f1c34e4fd57183c2d6afb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552be68ca20c0222fc5b9a7973375329b8b79f0bef203def9f118760d6104b91"
  end

  # Patch for macOS 11 on Apple Silicon support. Emailed to the maintainer in January 2021.
  # There is no upstream issue tracker or public mailing list.
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
__END__
diff --git a/src/include/pv-internal.h b/src/include/pv-internal.h
index db65eaa..176fc86 100644
--- a/src/include/pv-internal.h
+++ b/src/include/pv-internal.h
@@ -18,6 +18,14 @@
 #include <sys/time.h>
 #include <sys/stat.h>

+// Since macOS 10.6, stat64 variants are equivalent to plain stat, and the
+// suffixed versions have been removed in macOS 11 on Apple Silicon. See stat(2).
+#ifdef __APPLE__
+#define stat64 stat
+#define fstat64 fstat
+#define lstat64 lstat
+#endif
+
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/src/pv/number.c b/src/pv/number.c
index d841402..3f5f1e5 100644
--- a/src/pv/number.c
+++ b/src/pv/number.c
@@ -7,6 +7,7 @@
 #endif
 #include "pv.h"

+#include <stddef.h>

 /*
  * This function is used instead of the macro from <ctype.h> because
