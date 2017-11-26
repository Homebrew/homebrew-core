class Librealsense < Formula
  desc "Camera capture for Intel RealSense F200, SR300 and R200"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.8.2.tar.gz"
  sha256 "5a2174cafb87c5b2587b72df9d00f5aec37d3e1fe356388e88563702d20ac130"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "7b1142f28946da98bae0060cfe268125416d00ea378c183bf595e7d74a086a59" => :high_sierra
    sha256 "b021e1e543b4d593f10639c9606b6b4ddce76173df89f38e66355e0a21aa9312" => :sierra
    sha256 "03545104126d600ac1c083bd6484245a5fa105503058ab8a59323fb524c653af" => :el_capitan
  end

  option "with-examples", "Install examples"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw" if build.with? "examples"
  depends_on "libusb"

  def install
    args = std_cmake_args

    args << "-DBUILD_EXAMPLES=OFF" if build.without? "examples"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include<stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal shell_output("./test").strip, version.to_s
  end
end
