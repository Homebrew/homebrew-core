class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "a5f0266673c59028eab6ceeddd8b862c70abfeb32fb7a5387c16bf46f3269ab2"
  license "MIT"
  head "https://github.com/pantor/inja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "231ca1e3911473b3cad187701813504adcb75628d382b7bb80f08f481728315f"
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
