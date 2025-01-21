class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.8.7.tar.gz"
  sha256 "c957a6955eac415088a879459c54141a2896edc9b40c457899ed2c4280b994c8"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf538b93882ea192c1f509700b1aad37730e64c34145a5ade9f2202e9db930ec"
    sha256 cellar: :any,                 arm64_sonoma:  "f24b3611f2bf0ad53a62941d92b14f9237d32c75a99e4ba27809e905cd27e95f"
    sha256 cellar: :any,                 arm64_ventura: "5c8d8aabd272721f4ab8bd190b959e6af67bd3ec1e4140b25b561fd4477f967d"
    sha256 cellar: :any,                 sonoma:        "d82286938bb7fc73cd2d1291e9c79fcd546c6c561900d3a3546d5e1d9c15617b"
    sha256 cellar: :any,                 ventura:       "ac37c9f70a8a8745b26192976d1caba0f08e169474a829a58489b1822e3f37d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a95870672e642ee8cacd40c588c7161cbc4bbe2263951e69d4f5a7c7dfbc96"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/liblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "include/libsais.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
