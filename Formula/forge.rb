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
    sha256 cellar: :any, arm64_big_sur: "4b486382c1785146a5402e58c00b04f558d2658357adc83bd776f2d6723fdd71"
    sha256 cellar: :any, big_sur:       "fd3aae454ad2558820ab753c0b087b4e70fba247e0291160bb96730a7a1f43c3"
    sha256 cellar: :any, catalina:      "ceb38edbdffc47e6ff4bf92deccdf71207c6af8dfcdc12b165bc8703ab44ae68"
    sha256 cellar: :any, mojave:        "044723ff63b38feac035fd16c8938b5f16eb47eebf6f78adadfe3064ca598493"
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
