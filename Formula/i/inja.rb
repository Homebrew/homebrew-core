class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "7155f944553ca6064b26e88e6cae8b71f8be764832c9c7c6d5998e0d5fd60c55"
  license "MIT"
  head "https://github.com/pantor/inja.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "78f7fb60abcd044a0fbd19d1723da834a8a754f4df1601de17a02b2010381666"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json"

  def install
    args = %w[
      -DBUILD_BENCHMARK=OFF
      -DINJA_USE_EMBEDDED_JSON=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <inja/inja.hpp>

      int main() {
          nlohmann::json data;
          data["name"] = "world";

          inja::render_to(std::cout, "Hello {{ name }}!\\n", data);
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{include}", "-I#{Formula["nlohmann-json"].opt_include}"
    assert_equal "Hello world!\n", shell_output("./test")
  end
end
