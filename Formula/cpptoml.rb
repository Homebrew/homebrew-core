class Cpptoml < Formula
  desc "Header-only library for parsing TOML"
  homepage "https://github.com/skystrife/cpptoml"
  url "https://github.com/skystrife/cpptoml/archive/v0.1.1.tar.gz"
  sha256 "23af72468cfd4040984d46a0dd2a609538579c78ddc429d6b8fd7a10a6e24403"
  license "MIT"
  head "https://github.com/skystrife/cpptoml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7a282ff39f40484331c51d49f65289f729587d2c7c5d575c97e9cc75c6d153aa"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DENABLE_LIBCXX=#{ENV.compiler == :clang ? "ON" : "OFF"}
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
