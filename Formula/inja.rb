class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/v3.2.0.tar.gz"
  sha256 "825e1f0076504b5aac99cc9ad8c4cbfdc33e57c06c40353f2d7b93a33caae17d"
  license "MIT"
  head "https://github.com/pantor/inja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "872f713878bc80ab3b5b789dcf85f95e9144f7ae299091b71b9f7851efd139d9" => :big_sur
    sha256 "953dc5ef432b2331176524d03ee16ee6ea3f94ed59c91f633fe615c85407b5f5" => :arm64_big_sur
    sha256 "2dc3622a52c97e3bd5824127000fc8ee4b5a505c5303591cec8ca2f5c7b3320e" => :catalina
    sha256 "e93bba969f441b2425e10ec5849b5f904a932bad7b6318b07dc62dc20bae7a5a" => :mojave
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
