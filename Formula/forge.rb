class Forge < Formula
  desc "High Performance Visualization"
  homepage "https://github.com/arrayfire/forge"
  url "https://github.com/arrayfire/forge/archive/v1.0.7.tar.gz"
  sha256 "d7dbef8106ded73e515f38ca573b1bd79d93f233722f26b4ad5b4d184ace5384"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f3a2101af773f47ef9da29e1468f6af7f9a81c418111930e2f88362581249d57"
    sha256 cellar: :any, big_sur:       "a013b723b0118001a054cb6f0d3d917f90e9823c376718a3057bf9a1ba250ed1"
    sha256 cellar: :any, catalina:      "5321a0dd20592b5450308b4f527d75c1547b964fb1a7e1eaba9c6facdc46fe1c"
    sha256 cellar: :any, mojave:        "17d114d5023f66c30cf3378d43031d5847cb85ac4e529cba849752333bad8cbb"
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
