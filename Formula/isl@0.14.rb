class IslAT014 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.14.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.14.tar.bz2"
  sha256 "7e3c02ff52f8540f6a85534f54158968417fd676001651c8289c705bd0228f36"

  bottle do
    cellar :any
    rebuild 1
    sha256 "24a03da7808be89c8b3872bf44f4cf084c6f55602de47a7fa24b11cdcd70dc59" => :sierra
    sha256 "9607fffe97f967e33867fa9b9aa27818cd535774ce5b4dc9702d372a6e037b69" => :el_capitan
    sha256 "bce9482d827461585725d445416b26f89b523cb9dfa6acb3580999e0f7d5c1ee" => :yosemite
  end

  keg_only :versioned_formula

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
