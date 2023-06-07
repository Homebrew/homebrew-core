class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/v3.4.0.tar.gz"
  sha256 "7155f944553ca6064b26e88e6cae8b71f8be764832c9c7c6d5998e0d5fd60c55"
  license "MIT"
  head "https://github.com/pantor/inja.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5af855be623e2ed9baf2182e6b645efc7ec85b13e6a3485237dd35cc661ce7ef"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json"

  def install
    system "cmake", ".", "-DBUILD_TESTING=OFF",
                         "-DBUILD_BENCHMARK=OFF",
                         "-DINJA_USE_EMBEDDED_JSON=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <inja/inja.hpp>

      int main() {
          nlohmann::json data;
          data["name"] = "world";

          inja::render_to(std::cout, "Hello {{ name }}!\\n", data);
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{include}", "-I#{Formula["nlohmann-json"].opt_include}"
    assert_equal "Hello world!\n", shell_output("./test")
  end
end
