class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://github.com/signalwire/libks/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "cd0d8504870c2e0e1306e55fd27dede976ab9f3a919487bc10b526576d24d568"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/ks_hash.c
    "HPND",         # src/ks_pool.c
    :public_domain, # src/ks_utf8.c, src/ks_printf.c
  ]
  head "https://github.com/signalwire/libks.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4e047c7d6a018d97d15aed23f7898d8f1f4f0f46c7fe9ae790432b082e7cc1c"
    sha256 cellar: :any,                 arm64_sequoia: "82aa683dcba005cb4012c17026023457c8effed0966553cd4b2bcd9549723f1b"
    sha256 cellar: :any,                 arm64_sonoma:  "1a17d6bfb39fd8fd205dea626914b248aef3f3886cf1d3f977186b6275fcdc15"
    sha256 cellar: :any,                 sonoma:        "6bfeeb306bea73531d3ce22ee0f92292024cbd1c20e3f1325cb14df1b149145a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cf5d4dd4dfe67a804525da361f14112da1ebae458b30f7a135c1ff9963a51e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc07b908ad7fdd8b6eab80ff9d607542c225a1ef81f8fb061798ee812a68c18"
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
