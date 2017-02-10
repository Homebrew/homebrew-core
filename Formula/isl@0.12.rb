class IslAT012 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr/"
  bottle do
    cellar :any
    rebuild 1
    sha256 "9ca9d2bc65afcdce0d1816a98273701a2381c5ae8b58e47b2237d0dd89d6181c" => :sierra
    sha256 "57e01a30d3847bfa805c21e0cf8b45bfe958e10a0d3c2e8d225e780dba6f93f5" => :el_capitan
    sha256 "4da54a5f24e4d7dd0cd315096ee4a3c3a26388d8368f80b6a9bc0735c7b259ac" => :yosemite
  end

  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.12.2.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2"
  sha256 "f4b3dbee9712850006e44f0db2103441ab3d13b406f77996d1df19ee89d11fb4"

  keg_only :versioned_formula

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
