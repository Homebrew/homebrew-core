class IslAT011 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.11.1.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.11.1.tar.bz2"
  sha256 "095f4b54c88ca13a80d2b025d9c551f89ea7ba6f6201d701960bfe5c1466a98d"

  bottle do
    cellar :any
    sha256 "b52e01c560ac6abb87dd6bad6953295374b5b947e6b08757cf704743bec283b7" => :sierra
    sha256 "7cd0df5b49c0652fb1c0d97b4f96c7d24294c7c55c5cb1744f74344af9875b55" => :el_capitan
    sha256 "2f169ec06b1bf91a7ce2ca96438acea4498aa746c5c8b9e2a2deeca02f7187cc" => :yosemite
  end

  keg_only "Older version of isl"

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
