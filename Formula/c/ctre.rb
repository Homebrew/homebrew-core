class Ctre < Formula
  desc "Compile-time PCRE-compatible regular expression matcher for C++"
  homepage "https://compile-time-regular-expressions.readthedocs.io/"
  url "https://github.com/hanickadot/compile-time-regular-expressions/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "b17e6c9a6cc0cea65132f62a6c699cefed952721063569d6339eb3ca471045e6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e036c6ffa7b43852b5caa01c52e4caca22f14bc39d6ee613cd7ea67b3fc22dfc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include <ctre-unicode.hpp>
      #include <cassert>
      #include <iostream>

      int main()
      {
        const auto m = ctre::match<"[a-z]+([0-9]+)">("test123");
        assert(m);
        std::cout << m.get<1>();
      }
    CPP
    system ENV.cxx, "test.cxx", "-o", "test", "-std=c++20", "-I#{include}"
    assert_equal "123", shell_output("./test")
  end
end
