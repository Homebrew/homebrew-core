class Cpptoml < Formula
  desc "Header-only library for parsing TOML"
  homepage "https://github.com/skystrife/cpptoml"
  url "https://github.com/skystrife/cpptoml/archive/v0.1.1.tar.gz"
  sha256 "23af72468cfd4040984d46a0dd2a609538579c78ddc429d6b8fd7a10a6e24403"
  license "MIT"
  revision 1
  head "https://github.com/skystrife/cpptoml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5dd8ccfa15e88651af7ad7815bf041ead83e5afbf72f7a6d7c2e5da4a1e0da5b"
  end

  depends_on "cmake" => :build

  # Fix library support for GCC 11+ by adding include for limits header.
  # Upstream PR: https://github.com/skystrife/cpptoml/pull/123
  patch do
    url "https://github.com/skystrife/cpptoml/commit/c55a516e90133d89d67285429c6474241346d27a.patch?full_index=1"
    sha256 "29d720fa096f0afab8a6a42b3382e98ce09a8d2958d0ad2980cf7c70060eb2c1"
  end

  def install
    args = %W[
      -DENABLE_LIBCXX=#{(ENV.compiler == :clang) ? "ON" : "OFF"}
      -DCPPTOML_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "cpptoml.h"
      #include <iostream>

      int main() {
        auto brew = cpptoml::parse_file("brew.toml");
        auto s = brew->get_as<std::string>("str");

        if (s) {
          std::cout << *s << std::endl;
          return 0;
        }

        return 1;
      }
    EOS

    (testpath/"brew.toml").write <<~EOS
      str = "Hello, Homebrew."
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "test.cc", "-o", "test"
    assert_equal "Hello, Homebrew.", shell_output("./test").strip
  end
end
