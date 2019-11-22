class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.30.1.tar.gz"
  sha256 "379c2b8248b1f550222dcf0fbfb1d77037014a7d8e3ae9265d599b3d3f177c11"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "f1e09f226e1580f648f825ebe78911d54a565683649afc8dfbfdee30e8f10956" => :catalina
    sha256 "17e9d36f4e7b0b4fb245dbf29f13295d2ee1d97f96b7ce4c08fc828ebfc639e1" => :mojave
    sha256 "938e52912ddf7ff5546547d9e37af48db8093a13c0f7b7fe962231d0eefdb3e6" => :high_sierra
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
