class IslAT018 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.18.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
  sha256 "0f35051cc030b87c673ac1f187de40e386a1482a0cfdf2c552dd6031b307ddc4"
  license "MIT"

  bottle do
    cellar :any
    sha256 "4d22193093ee43ec29988ecadd20b01359291475c78a43d9053e00b78991fc7f" => :big_sur
    sha256 "44fe4a7f5ed00ff3b3ba06a37d3b6d4633e7532c841d4e02fa1cb2678afc018c" => :arm64_big_sur
    sha256 "728e3b1ab4e7c7cf6298e80c398dfdb8012c1b5c77fb54261d618d094bd9a1bb" => :catalina
    sha256 "efcde3c18baf1ee3e76312758ab5a95cb4df68267d7273003d519abce2ad6c87" => :mojave
    sha256 "0525751dc4fd778bf8be05f743d798d9229e9955999d06a1cfbecee33d737a38" => :high_sierra
  end

  keg_only :versioned_formula

  deprecate! date: "2020-11-05", because: :versioned_formula

  depends_on "gmp"

  def install
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
