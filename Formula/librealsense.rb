class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/2.14.0.tar.gz"
  sha256 "3d7d4b6231e792d05384bc32b33f72946936001db0499039a95ad0572e9e336f"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "ad8a532cb189513abcc69c86ef2f4a3b971e2f195611dd58ada52b75ffe614a5" => :high_sierra
    sha256 "d25b6aa89d70169f8b2bf675a8e9c890c89d88f2f1929b7eee1b9de1c62d1e38" => :sierra
    sha256 "895ceb69361e777bdc35201a1b39c99e7a12ec52446fed8092de0ad5651c0e6d" => :el_capitan
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
