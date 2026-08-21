class LsHpack < Formula
  desc "HTTP/2 HPACK header compression library"
  homepage "https://github.com/litespeedtech/ls-hpack"
  url "https://github.com/litespeedtech/ls-hpack/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "430a1a36029e0ae1c81eaa0b2356920f1e65fde1cdd722351c671ebe513b7a96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e9c54570dbe137cbebfb5d7fb4ac142305e907baac4b3143601bf9377963589"
    sha256 cellar: :any,                 arm64_sequoia: "2210697f2a76087a665c87ce4c7d1f61a0cabc7c6629a3a533dfbe2a5437241f"
    sha256 cellar: :any,                 arm64_sonoma:  "0828958f22dfcf643cd04d89e4722252ba5ec1f5cbce07ebc617b9d06500ce20"
    sha256 cellar: :any,                 sonoma:        "0db67bc747169d4d1cbd5ca392087a999bc1d685174d884f969fc218be5c1051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4647ce2255e0b71bb050c04d4d6c54907fdc13440005a1e8867b76074f420a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62bc271fe85f47c2bfdd282938e0b531f325731780ef93bb381d49377600f8f"
  end

  depends_on "cmake" => :build

  def install
    # Upstream has no install() rules in CMakeLists, so install artifacts manually.
    # https://github.com/litespeedtech/ls-hpack/issues/21
    system "cmake", "-S", ".", "-B", "build",
                  "-DCMAKE_BUILD_TYPE=Release",
                  "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                  "-DSHARED=1",
                  "-DLSHPACK_XXH=1",
                  *std_cmake_args
    system "cmake", "--build", "build"

    lib.install "build/#{shared_library("libls-hpack")}"
    include.install "lshpack.h", "lsxpack_header.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <lshpack.h>

      int main(void) {
        struct lshpack_dec dec;
        lshpack_dec_init(&dec);
        lshpack_dec_cleanup(&dec);
        assert(LSHPACK_MAJOR_VERSION >= 2);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lls-hpack", "-o", "test"
    system "./test"
  end
end
