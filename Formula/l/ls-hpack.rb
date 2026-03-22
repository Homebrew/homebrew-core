class LsHpack < Formula
  desc "HTTP/2 HPACK header compression library"
  homepage "https://github.com/litespeedtech/ls-hpack"
  url "https://github.com/litespeedtech/ls-hpack/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "4abeeb786d6211d0aaf13ef3df7651c765c2ffb58cd226ec5c9e6e8b6d801ca1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f91663e7b38b1f45409a01931768ffdb3bc2c51718213bdfdaa71b2eb0a2358"
    sha256 cellar: :any,                 arm64_sequoia: "bd14209d3b86ebd0eaf6918a9b21b9f2539a88812c7523ec95320495bd3ce487"
    sha256 cellar: :any,                 arm64_sonoma:  "2d8e795e730e48b08df95f10b0a11c16541894bba05028fb6306c833e4577b9a"
    sha256 cellar: :any,                 sonoma:        "311fc1dc37b213162568e624a2b80142023fbce581443f4245b0d2c83b388d2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb97b47e4d51ebc3e308a82d206d8d7e1763be91b2a351619b09093def373860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6edeb50e88418f23113ed87ebfc7e39d834f718e2c379750869e60d2cb7bf7f"
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
