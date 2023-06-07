class Chmlib < Formula
  desc "Library for dealing with Microsoft ITSS/CHM files"
  homepage "http://www.jedrea.com/chmlib/"
  url "http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz"
  mirror "https://download.tuxfamily.org/slitaz/sources/packages/c/chmlib-0.40.tar.gz"
  sha256 "512148ed1ca86dea051ebcf62e6debbb00edfdd9720cde28f6ed98071d3a9617"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?chmlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "fb27ebeee48d99f6637aae0da57043863119406a49fafe09deac78badcb723f8"
    sha256 cellar: :any,                 arm64_monterey: "23e464348836e12bf5835bfdf1acbcdcce344151d12cfa2a055d689c205b6e82"
    sha256 cellar: :any,                 arm64_big_sur:  "3ab46a541a6aeb2ac904a74fa1433e48bfca91a382e8e8b27290d0597581f520"
    sha256 cellar: :any,                 ventura:        "73986282be1f4d01cfdaebb1aa2b68683143a60acd35cf67235ed8d4f8f0df31"
    sha256 cellar: :any,                 monterey:       "4d4a29e60712457e4ea3838947a95959dbc0f68338514edd3817d6ee122afbf4"
    sha256 cellar: :any,                 big_sur:        "af369d3e427b36281f053f65a0d5be2a269c2a0fb80c87443baa066892d0652c"
    sha256 cellar: :any,                 catalina:       "96d7cb33260c72012f24f383054b7f2505f815f0e3e24298229b5712f8a66cfa"
    sha256 cellar: :any,                 mojave:         "1718a0a9343788718b4207596ebff457f5214879319292cc1608254374720944"
    sha256 cellar: :any,                 high_sierra:    "426b95744d071ad76399ee240400ab74bcec9057735cbfeb2d433501105060ef"
    sha256 cellar: :any,                 sierra:         "9781c76f933beca002df542d2db0644e51766568d9399f9e73dc39b9e896f539"
    sha256 cellar: :any,                 el_capitan:     "6b834a6ae6e95f8daaa726fd6ae1a2d3e60335f98862fea9e790c24e5a6411d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a085287bba377e847d027575fd848cbadc0f6b5bd8f2efc008cc54d8f32d32"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end
  # Add aarch64 to 64-bit integer platform list.
  patch :DATA

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <chm_lib.h>
      int main() {
        struct chmFile* chm = chm_open("file-that-doesnt-exist.chm");
        return chm != 0; // Fail if non-null.
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lchm", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/chm_lib.c b/src/chm_lib.c
index 6c6736c..06908c0 100644
--- a/src/chm_lib.c
+++ b/src/chm_lib.c
@@ -164,7 +164,7 @@ typedef unsigned long long      UInt64;

 /* x86-64 */
 /* Note that these may be appropriate for other 64-bit machines. */
-#elif __x86_64__ || __ia64__
+#elif __x86_64__ || __ia64__ || __aarch64__
 typedef unsigned char           UChar;
 typedef short                   Int16;
 typedef unsigned short          UInt16;
