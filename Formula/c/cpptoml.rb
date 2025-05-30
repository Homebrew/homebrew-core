class Cpptoml < Formula
  desc "Header-only library for parsing TOML"
  homepage "https://github.com/skystrife/cpptoml"
  url "https://github.com/skystrife/cpptoml/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "23af72468cfd4040984d46a0dd2a609538579c78ddc429d6b8fd7a10a6e24403"
  license "MIT"
  revision 1
  head "https://github.com/skystrife/cpptoml.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c7277d9959d90daba22c6e5e464e5d9877c6dce18d25932a5a7d53feac061139"
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
