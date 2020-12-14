class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/v3.1.0.tar.gz"
  sha256 "f4210493e7e3c62d3050ca6e5e9dd72823ec4125a469fa9b28519d7f32fc9731"
  license "MIT"
  head "https://github.com/pantor/inja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd8ee91b85b6fd8083a8f05ad96fffffe8890b7b06240868c14dfaf31e34589b" => :big_sur
    sha256 "2d2e56f3daecf8306ebb2df948024c6ce7115e26cc160496538ca05900c6d8a5" => :catalina
    sha256 "22ea5918d1033829ab77202e877ce6f79d0bcb965feee60081004654a3ea60b4" => :mojave
    sha256 "9a67ee6245a22e809dd4c7fc29227b42bbc443f58bb24fdc7258929a99c7d0f3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json"

  # fix `nlohman_json` installation issue
  # remove in next release
  patch do
    url "https://github.com/pantor/inja/commit/a57b745.patch?full_index=1"
    sha256 "69a744a66ac6343204e99f1bdd82ef251472bca9b4f72e16db632740157aebe5"
  end

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
