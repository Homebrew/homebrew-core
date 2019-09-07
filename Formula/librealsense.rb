class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.28.0.tar.gz"
  sha256 "2a74dc5a25a469faad09b9784440927dfad9142e90ccc04249d9478a3cde00e0"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "af5fbc59a8e09c59a54bd35ccab4155a378469e897b6f8a199884d123cdd53cf" => :mojave
    sha256 "92930511177c27a459c5637ce3e7599663b51be5a9129022286fd8ee91b660f0" => :high_sierra
    sha256 "b31d6de65f392b1080997c56a15cc961a596e82fcbb6fe75be5e99f4a708327f" => :sierra
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
