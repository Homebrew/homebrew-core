class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "https://isl.gforge.inria.fr/"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.22.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.22.orig.tar.xz"
  sha256 "6c8bc56c477affecba9c59e2c9f026967ac8bad01b51bdd07916db40a517b9fa"

  bottle do
    cellar :any
    sha256 "1f42c08dd84a2f418c8446be2679f027d8b1250d337b5e3135c401eba578cbb7" => :catalina
    sha256 "f9188b5d486b2a835cd865f219be1a9848ce3926e27089a1538ee989db65447d" => :mojave
    sha256 "d997d49958218e521bc4f73369414ff9fad040d28601d94012e4c68cd090ea93" => :high_sierra
    sha256 "d5dc353916cd98da04552a3d7cb86a3203612df422c4e9389e13e12f86945865" => :sierra
  end

  head do
    url "https://repo.or.cz/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "check"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
