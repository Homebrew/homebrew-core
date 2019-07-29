class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.24.0.tar.gz"
  sha256 "0bcdce5f4f7ffe15897f58d8fc474e414e9688443dd4962bebd572ea5ef9b19c"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "c44356fb9f0c72256d05e6b04db450b244f22858d4c258bc551677ebef4d4bac" => :mojave
    sha256 "fed894500f4024a4a91fffbeb408371c49e87e3ce59509ff26d812b68ae27800" => :high_sierra
    sha256 "a52820b4404623ce7046c5e77755073f3644968f1ca3cae62bd7e900f7cc56f9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
