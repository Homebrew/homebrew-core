class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://github.com/signalwire/libks/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "7142800a0c9095ce0e52308c815026a8ad2a197f519363c050fe441039de20be"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/ks_hash.c
    "HPND",         # src/ks_pool.c
    :public_domain, # src/ks_utf8.c, src/ks_printf.c
  ]
  revision 1
  head "https://github.com/signalwire/libks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b0888f7c1d2d8a5e439fe81600e680cfb85b995f4ffd96d2de7d72dd43116fb"
    sha256 cellar: :any, arm64_tahoe:       "858b8192898015456503706b214165b833c6ed0ea983c32527c415693b86d666"
    sha256 cellar: :any, arm64_sequoia:     "b114c142eee06c6cd4b58340e4dfcb7cfb697c5f2690002f45ccead1b2d819d7"
    sha256 cellar: :any, arm64_linux:       "23a0b83aade5890794cbd86890c454ccdcaa33101529834f41a4f73e3bf1f4f9"
    sha256 cellar: :any, x86_64_linux:      "40bb94abb01ceda140cb41e6f6f7fe9831f119db0c4f8c76e0ca307055cc994e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = ["-DWITH_PACKAGING=OFF"]
    args << "-DUUID_ABS_LIB_PATH=#{MacOS.sdk_for_formula(self).path}/usr/lib/libSystem.tbd" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Part of https://github.com/signalwire/libks/blob/master/tests/testrealloc.c
    (testpath/"test.c").write <<~C
      #include <libks/ks.h>
      #include <assert.h>

      int main(void) {
        ks_pool_t *pool;
        uint32_t *buf = NULL;
        ks_init();
        ks_pool_open(&pool);
        buf = (uint32_t *)ks_pool_alloc(pool, sizeof(uint32_t) * 1);
        assert(buf != NULL);
        ks_pool_free(&buf);
        ks_pool_close(&pool);
        ks_shutdown();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}/libks2", "-I#{formula_opt_include("openssl@4")}",
           "-L#{lib}", "-L#{formula_opt_lib("openssl@4")}", "-lks2"
    system "./test"
  end
end
