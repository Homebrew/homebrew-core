class Pxz < Formula
  desc "Compression utility"
  homepage "https://jnovy.fedorapeople.org/pxz/"
  url "https://jnovy.fedorapeople.org/pxz/pxz-4.999.9beta.20091201git.tar.xz"
  version "4.999.9"
  sha256 "df69f91103db6c20f0b523bb7f026d86ee662c49fe714647ed63f918cd39767a"
  revision 2

  bottle do
    cellar :any
    sha256 "f48d8b406aa774291008f8257841707c204ef6b30e11345e0cf534c6d8e48f29" => :sierra
    sha256 "ff0ce76c096fd81e249fd322672575b108c84e72e9a82600fd8260b0e03a167c" => :el_capitan
    sha256 "ff8e88582e0facfb65f71faac849ae883bc5e853ddab1093a565f536e9bdb442" => :yosemite
  end

  head do
    url "https://github.com/jnovy/pxz.git"

    # Rebased version of an upstream PR to fix the build on macOS
    # https://github.com/jnovy/pxz/pull/5
    patch :DATA
  end

  depends_on "gcc"
  depends_on "xz"

  fails_with :clang do
    cause "pxz requires OpenMP support"
  end

  def install
    # Fixes usage of MAP_POPULATE for mmap (linux only). Fixed upstream.
    inreplace "pxz.c", "MAP_SHARED|MAP_POPULATE", "MAP_SHARED" if build.stable?
    system "make", "CC=#{ENV.cc}"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    (testpath/"test").write "foo bar"
    system "#{bin}/pxz", "test"
    assert File.exist? "test.xz"
  end
end

__END__
diff --git a/pxz.c b/pxz.c
index 153f28c..d76f94a 100644
--- a/pxz.c
+++ b/pxz.c
@@ -23,11 +23,36 @@

 #include <string.h>
 #include <stdio.h>
+#ifdef HAVE_STDIO_EXT_H
 #include <stdio_ext.h>
+#else
+#include <sys/param.h>
+#ifdef BSD
+#define __fpending(fp) ((fp)->_p - (fp)->_bf._base)
+#endif
+#endif
 #include <stdlib.h>
 #include <inttypes.h>
 #include <unistd.h>
+#ifdef HAVE_ERROR_H
 #include <error.h>
+#else
+#include <stdarg.h>
+/* Emulate the error() function from GLIBC */
+char* program_name;
+void error(int status, int errnum, const char *format, ...) {
+	va_list argp;
+	fprintf(stderr, "%s: ", program_name);
+	va_start(argp, format);
+	vfprintf(stderr, format, argp);
+	va_end(argp);
+	if (errnum != 0)
+		fprintf(stderr, ": error code %d", errnum);
+	fprintf(stderr, "\n");
+	if (status != 0)
+		exit(status);
+}
+#endif
 #include <errno.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -258,6 +283,7 @@ int main( int argc, char **argv ) {
	lzma_filter filters[LZMA_FILTERS_MAX + 1];
	lzma_options_lzma lzma_options;

+	program_name = argv[0];
	xzcmd_max = sysconf(_SC_ARG_MAX);
	page_size = sysconf(_SC_PAGE_SIZE);
	xzcmd = malloc(xzcmd_max);
