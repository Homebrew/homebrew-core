class Nbytes < Formula
  desc "Library of byte handling functions extracted from Node.js core"
  homepage "https://github.com/nodejs/nbytes"
  url "https://github.com/nodejs/nbytes/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "5158c92a34b02f54778ae7367dab77cc02861c69f4d8cfd4eeed608d586ca900"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "4e8fbdd7072c42de97ae1e348a2a7f1df7338c4a1650ef3f9c6ebb29a388849b"
    sha256 cellar: :any, arm64_golden_gate: "38a76d911a5ac69042db2acc0f639f672e1fe26e4f8372dcbf993bed6af4c367"
    sha256 cellar: :any, arm64_tahoe:       "5a2accb231bac27986c58efd5552413830213723ebc3d62cd8de5058ac82a749"
    sha256 cellar: :any, arm64_sequoia:     "274197cd3d7ed773e8693a715bb5d0d5498f1d799e82275ad28d4bb359cad127"
    sha256 cellar: :any, arm64_linux:       "0366d9fd5ed77399526563bbad9953552f0c88859fe6c085bf4d54dac2349ad1"
    sha256 cellar: :any, x86_64_linux:      "340fb555250888abef01c5648cbdae16b269e2ae31356d41e21e35225b94bc6e"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
