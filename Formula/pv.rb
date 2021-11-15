class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.20.tar.bz2"
  sha256 "e831951eff0718fba9b1ef286128773b9d0e723e1fbfae88d5a3188814fdc603"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26f3259815cfa65ca346d1997762e2581c410b1213ae05af3098f5fe0016ac86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c800d34963f021bdef3489cc9bc4adc2709ec1a364954d0babdbe532a28a126"
    sha256 cellar: :any_skip_relocation, monterey:       "d340afd9df619d826d431cdc829226b76a0622bf0135860c44c7848f7e1a0908"
    sha256 cellar: :any_skip_relocation, big_sur:        "99cd5022561f488b19844267da97a2e211fed36d9300661f3a4ef23c923c6178"
    sha256 cellar: :any_skip_relocation, catalina:       "ac11cfd62d2bcd5e7191ce2fef6548269d466e50329e6b9c46887cd95ff1e9fc"
    sha256 cellar: :any_skip_relocation, mojave:         "8dd7e214b710ac5224eb994ee0fec8e5af14f8ce67cff3c343bdeb3443fb2f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2992e31bcce7194a85d1a2677b8bcf3f5f3e1c6649c2c0b38197b243fc4465"
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
