class IslAT018 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "https://libisl.sourceforge.io/isl-0.18.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
  sha256 "0f35051cc030b87c673ac1f187de40e386a1482a0cfdf2c552dd6031b307ddc4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "44fe4a7f5ed00ff3b3ba06a37d3b6d4633e7532c841d4e02fa1cb2678afc018c"
    sha256 cellar: :any,                 big_sur:       "4d22193093ee43ec29988ecadd20b01359291475c78a43d9053e00b78991fc7f"
    sha256 cellar: :any,                 catalina:      "728e3b1ab4e7c7cf6298e80c398dfdb8012c1b5c77fb54261d618d094bd9a1bb"
    sha256 cellar: :any,                 mojave:        "efcde3c18baf1ee3e76312758ab5a95cb4df68267d7273003d519abce2ad6c87"
    sha256 cellar: :any,                 high_sierra:   "0525751dc4fd778bf8be05f743d798d9229e9955999d06a1cfbecee33d737a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d90ca0810ac78ac9357f86cf245ec9dfdc7c2171646d4993972d36c1b84e35b"
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
    system "make"
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
