class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/v3.3.0.tar.gz"
  sha256 "e628d994762dcdaa9a97f63a9b8b73d9af51af0ffa5acea6bdbba0aceaf8ee25"
  license "MIT"
  head "https://github.com/pantor/inja.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "173097b1702c4d03d7f6010dba26a9163cde204d021762cc8108cb171a6e27b2"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
           "-I#{include}", "-I#{Formula["nlohmann-json"].opt_include}"
    assert_equal "Hello world!\n", shell_output("./test")
  end
end
