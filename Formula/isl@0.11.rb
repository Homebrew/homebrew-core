class IslAT011 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.11.1.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.11.1.tar.bz2"
  sha256 "095f4b54c88ca13a80d2b025d9c551f89ea7ba6f6201d701960bfe5c1466a98d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "88be318c19e233dd4bb62760d22d42f03b9d92edc9a3f058b6ec745ad0f162eb" => :sierra
    sha256 "185efaee527e73a30355ad88cad43e407dc26b169df01531559d377e33eff971" => :el_capitan
    sha256 "beb1434e8feb9a8b1df64b9d5b6cd7b66fdd170fe22b0f5078382377162ee2ee" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "gmp@4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lisl",
      "-I#{include}", "-I#{Formula["gmp@4"].include}", "-o", "test"
    system "./test"
  end
end
