class Forge < Formula
  desc "High Performance Visualization"
  homepage "https://github.com/arrayfire/forge"
  url "https://github.com/arrayfire/forge/archive/v1.0.8.tar.gz"
  sha256 "77d2581414d6392aa51748454b505a747cd63404f63d3e1ddeafae6a0664419c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "beb86dc4a75fa4f6c4ac1948358c1dac9e3e45d157567c05430f44fbad218206"
    sha256 cellar: :any,                 arm64_big_sur:  "648b7ce9d0146143fd3aa7ce40ac8989bc5af8552b58f6a54406d67b9dc37bc4"
    sha256 cellar: :any,                 monterey:       "99fa6a4741e4c98221187530cde328cec9e8faf2a660b31b11c49573986fb907"
    sha256 cellar: :any,                 big_sur:        "cac8109b34dd4f8e8f76dcd21d7fbd765fe5155cc150e22114158f42448244f6"
    sha256 cellar: :any,                 catalina:       "7081807afb00024e9d58507d6280f52fc2a9b9ec4dd3076ea5d8a77552e183c6"
    sha256 cellar: :any,                 mojave:         "c115a44a1b7cc3c7f0fc512bab0a4a7f91a00b7357c0f286fada3a10c2d8b1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1591da537a4be701c5500b89ae05525d2390eef4d1d66cb49a9c219d500aa87"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "glm"
  depends_on "libx11"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <forge.h>
      #include <iostream>

      int main()
      {
          std::cout << fg_err_to_string(FG_ERR_NONE) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lforge", "-o", "test"
    assert_match "Success", shell_output("./test")
  end
end
