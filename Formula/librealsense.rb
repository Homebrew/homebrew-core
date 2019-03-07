class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.18.1.tar.gz"
  sha256 "2b6d71f20750abbdf2900efab0226828dcb28b5ebb9838a867dd8ac3a06fba30"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "899cf86d2f0813ba19fb8e343210731d2a2d38f992538eac709286a01ea90cc3" => :mojave
    sha256 "403ce3a775174338e58e8b3ee27bd8126bd44e70d259e60ce5c479f18ff22654" => :high_sierra
    sha256 "3004f2f105479b6545071715716a1a8841f8d9c62bfedc928fc895b53a974e67" => :sierra
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
