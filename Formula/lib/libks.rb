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
  head "https://github.com/signalwire/libks.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ef28559de9b88ff877d61cadd12106d76db260481a5c6b2b249d14c73a92eed"
    sha256 cellar: :any,                 arm64_sequoia: "6d1b6196aa2f683d53f88c8bcc68ace776ffcd0399d32d5591c8af27d9afdbb4"
    sha256 cellar: :any,                 arm64_sonoma:  "a878768d05de59a23ef1c26e055815435ec9636b44f63d2bdd3e1a7aac18b172"
    sha256 cellar: :any,                 sonoma:        "fe3802c0d94269e337d646eea8f0f659aaf55a7c6a69bc38c2a10b8dd4748733"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f4831ce43fc330e92ed2e24a70788f41f2de51e6e83c13accbb0dd46dc9fa1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77175840023117d13fec16f98c290ec4e7fb5e54508955e8e7fbc014f0ac59a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/libks2", "-L#{lib}", "-lks2"
    system "./test"
  end
end
