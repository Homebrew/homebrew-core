class Cpptoml < Formula
  desc "Header-only library for parsing TOML"
  homepage "https://github.com/skystrife/cpptoml"
  url "https://github.com/skystrife/cpptoml/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "23af72468cfd4040984d46a0dd2a609538579c78ddc429d6b8fd7a10a6e24403"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/skystrife/cpptoml.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "e72f93b179af9b4fa32b68d95740bf75b33e35fe035c25f05f63e625f7658a0d"
  end

  depends_on "cmake" => :build

  # Fix library support for GCC 11+ by adding include for limits header.
  patch do
    url "https://github.com/skystrife/cpptoml/commit/c55a516e90133d89d67285429c6474241346d27a.patch?full_index=1"
    sha256 "29d720fa096f0afab8a6a42b3382e98ce09a8d2958d0ad2980cf7c70060eb2c1"
    type :unofficial
    resolves "https://github.com/skystrife/cpptoml/pull/123"
  end

  # Add CMake 4.x compatibility
  patch do
    url "https://github.com/skystrife/cpptoml/commit/5e3493f7c8eea6e4d61134b42db232a63771be95.patch?full_index=1"
    sha256 "df368939c01a4f33981b69412800a2fa44d8423aedea24cb46a4dc557bafa7d2"
    type :unofficial
    resolves "https://github.com/skystrife/cpptoml/pull/132"
  end

  deny_network_access!

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
    (testpath/"test.cc").write <<~CPP
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
    CPP

    (testpath/"brew.toml").write <<~TOML
      str = "Hello, Homebrew."
    TOML

    system ENV.cxx, "-std=c++11", "-I#{include}", "test.cc", "-o", "test"
    assert_equal "Hello, Homebrew.", shell_output("./test").strip
  end
end
