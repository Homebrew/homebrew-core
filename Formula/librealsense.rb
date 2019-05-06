class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.21.0.tar.gz"
  sha256 "ebe553668ae70ad776b2a6ac0c1e6f636dc0dc50bacfe09c3caa86f17f7bd825"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "9e0c2dae75ee2faf76fa42be5592f9dec3234f7f1e8e9d393a86cb3ac2808765" => :mojave
    sha256 "2450e0cb70cd9ec8dbe3e96ee6d18a07fbcf0b2463b14ea0f2bbc813ff47c4ec" => :high_sierra
    sha256 "6c6a23bac78501fd18f7d8135a058a4a075ba02c4621d9e13c1011b138a97962" => :sierra
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
