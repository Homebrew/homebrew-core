class IslAT012 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr/"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.12.2.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2"
  sha256 "f4b3dbee9712850006e44f0db2103441ab3d13b406f77996d1df19ee89d11fb4"

  keg_only "Older version of isl"

  depends_on "gmp@4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["gmp@4"].opt_include}", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
