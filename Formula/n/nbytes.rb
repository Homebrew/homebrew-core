class Nbytes < Formula
  desc "Library of byte handling functions extracted from Node.js core"
  homepage "https://github.com/nodejs/nbytes"
  url "https://github.com/nodejs/nbytes/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "67f4b8363f12abb64c07a0cecf2bf2dce7ab47b5f8b9fd2efdb852ea254c2d40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc0a989ffab822c0ef0b5122cfc9f046be9b8c6b681dd09a3691c9963c44a282"
    sha256 cellar: :any,                 arm64_sequoia: "c320de81e5ba5364dd7159fcdcbac9fe3a1475e3d8f830d2115b5390c1261a10"
    sha256 cellar: :any,                 arm64_sonoma:  "38bf51d000e92a43262c605d5fb709eb5d9de5adcc243231adeac2bcccac4ce0"
    sha256 cellar: :any,                 sonoma:        "ee96a893bd236484dfb80e82f772830ce0ffd7f88d6943d6a8bb98f7a79ad65e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd63cfc842aa392cfd48b810f40fd586c567aa82e7c4c07f59e85681cae317c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd60fe046720705ec370907040b03d1b47c806b0b2544612374206f50e7a502a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-main.cpp").write <<~CPP
      #include <nbytes.h>
      #include <iostream>

      int main() {
        constexpr char input[] = "SGVsbG8sIFdvcmxkIQ=="; // "Hello, World!"
        char output[64] = {};
        size_t n = nbytes::Base64Decode(output, sizeof(output), input, sizeof(input) - 1);
        std::cout << output << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "test-main.cpp", "-I#{include}", "-L#{lib}", "-lnbytes", "-o", "test-main"

    assert_equal "Hello, World!\n", shell_output("./test-main")
  end
end
