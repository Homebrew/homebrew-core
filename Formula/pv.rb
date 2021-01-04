class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.6.tar.bz2"
  sha256 "608ef935f7a377e1439c181c4fc188d247da10d51a19ef79bcdee5043b0973f1"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b686e6d397914c00bd7041424edd76d3e2cecf6e72d4d4dd4a08002dd2846dc4" => :big_sur
    sha256 "a5a43d38f36d54dd3e01d70ab6faa68af3ddc7cb80302f02945d1344eee7b7d4" => :catalina
    sha256 "790e86acba53eecbff8e20753df00ef139dbc686d0dac27062d57c0a47eaac76" => :mojave
    sha256 "4beeaa40f09a609c2706a945ec04b2b6a156efc0befe9dc571ec426f3a152cba" => :high_sierra
    sha256 "231a659ee3aca5a6f474bc058ed02a0a5f2c366d04c8c56043d310644c46e393" => :sierra
    sha256 "d461d873a47091a52b6114ac0976f16b0ade9e13d02fa0609f574369b8cfc8f0" => :el_capitan
    sha256 "0c4d4a90c188370ed312490b7ff76fdb8a31399170cdc0ad5dfc1542af4c4fc0" => :yosemite
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
