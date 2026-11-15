class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://github.com/signalwire/libks/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "1e40d565e6a240eb3e767a50a759432ae1464ce1caa0116825d5d824e9a840ed"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/ks_hash.c
    "HPND",         # src/ks_pool.c
    :public_domain, # src/ks_utf8.c, src/ks_printf.c
  ]
  compatibility_version 1
  head "https://github.com/signalwire/libks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e6ec7fe5f3b2dadc28ce2a8a50046bc44b9b374dc2761e9381a85aaec2d17a19"
    sha256 cellar: :any, arm64_tahoe:       "d1c025f775f354fec28248f5914c60314aff5386fb5d17b0be33e76f6778f42a"
    sha256 cellar: :any, arm64_sequoia:     "ef945160828fb68f5f5f8ac60a7980d04ef94df56293d99521e8af01ff78b781"
    sha256 cellar: :any, arm64_linux:       "c3ea4fd2749ae15fc3f816b955d849a676fda40cf1b5a223c650312d3617c1f2"
    sha256 cellar: :any, x86_64_linux:      "a5d9d6d6a7f61c329701adc2e44fa40f136de80c64cf944adf34d3d288ab5ca6"
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
