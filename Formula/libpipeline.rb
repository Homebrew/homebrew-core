class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.0.tar.gz"
  sha256 "0d72e12e4f2afff67fd7b9df0a24d7ba42b5a7c9211ac5b3dcccc5cd8b286f2b"

  depends_on "pkg-config" => :run

  # Patch explanation:
  # Gnulib, part of man-db and libpipeline, externs a symbol called
  # `program_name`. This symbol is supposed to be defined by glibc, which is to
  # be expected on Linux. However, since we're on OS X, we don't have glibc and
  # so this symbol will not be defined. This is a known issue and several work-
  # arounds have been proposed by different people. One option is to use some
  # CFLAGS to suppress errors about undefined symbols. Unfortunately, this only
  # seems to work for man-db and doesn't work for other programs which link with
  # libpipeline. This patch is a more general solution and was almost included
  # in the Nix package manager at one point. For more info, visit these links:
  # https://stackoverflow.com/questions/36824434/libpipeline-fails-to-compile-on-mac-os-x
  # https://github.com/NixOS/nixpkgs/issues/15849
  # https://lists.gnu.org/archive/html/bug-gnulib/2015-02/msg00079.html
  patch :DATA

  def install
    ENV["CC"] = "#{ENV.cc} -arch x86_64"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include <pipeline.h>
      int main(void)
      {
        pipeline *p = pipeline_new_command_args("true", NULL);
        int status = pipeline_run(p);
        return status;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lpipeline", "-I#{include}", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/gnulib/lib/error.c b/gnulib/lib/error.c
index 31109df3..6b68cd15 100644
--- a/gnulib/lib/error.c
+++ b/gnulib/lib/error.c
@@ -110,9 +110,13 @@ int strerror_r ();
 #  endif
 # endif

+#if defined __APPLE__ && defined __MACH__
+#define program_name (((char **)*_NSGetArgv())[0])
+#else
 /* The calling program should define program_name and set it to the
    name of the executing program.  */
 extern char *program_name;
+#endif

 # if HAVE_STRERROR_R || defined strerror_r
 #  define __strerror_r strerror_r
