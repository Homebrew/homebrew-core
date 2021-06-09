class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.45.0.tar.gz"
  sha256 "878237243e4df054be9060efd0e997963138eff041c24c60bc02a7a78d76ff0c"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "54e95dddcbbc4659f5a1492ee451b26a454c78e3f7971551cc5def6d66be6d26"
    sha256 cellar: :any, catalina: "288689a9bc5a41847846b1f6142b54303a575f7ef518fb63ffc8c975ec524af8"
    sha256 cellar: :any, mojave:   "30a4fe7cc7fdbaf657a6416e75e4c44696ddb436bca379ef2846efd0864d9bb6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"
  depends_on "openssl@1.1"

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@1.1"].prefix

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
