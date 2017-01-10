class IslAT014 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.14.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.14.tar.bz2"
  sha256 "7e3c02ff52f8540f6a85534f54158968417fd676001651c8289c705bd0228f36"

  bottle do
    cellar :any
    sha256 "33114e084463d3b4f81bc82e37af5feec655840b43c143df1452b2a68f132fae" => :sierra
    sha256 "2149a627c0264bce672cd1db53f62ce1bb3d77d6013344559cc316d08cd09abc" => :el_capitan
    sha256 "a0f74e8b8c350176d4b90eaf1d5ea569e2ebf6b715a7c1403040b13a5c05b7a5" => :yosemite
  end

  keg_only "Older version of isl"

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
