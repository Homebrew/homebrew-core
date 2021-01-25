class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.6.tar.bz2"
  sha256 "608ef935f7a377e1439c181c4fc188d247da10d51a19ef79bcdee5043b0973f1"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9a0c1c557a100dfb114c8fb3566c97f8d91c436fcc6f9f36a733f462945e4f95" => :big_sur
    sha256 "9fa320894a6ae215794b2952ea60165dcfb63bdf3dda557a1998daaf5304df6b" => :arm64_big_sur
    sha256 "9bb586c4dab67989e7fa800e7c764d1d4ee153db8ad7a5ed3563270ca93a7497" => :catalina
    sha256 "1877dffe8804fac2fe6f77582100e2b5ea3fbb7a305c1cfd025e251ede08c98e" => :mojave
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
index 46d7496..fed25fe 100644
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
