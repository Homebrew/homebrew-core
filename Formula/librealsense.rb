class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.49.0.tar.gz"
  sha256 "2578ea0e75546aeebd908da732f52e0122bf37750d5a45f3adf92945a673aefd"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "bfcc6fb89a8cac2db7fe0d30b84c4d7b1585f02e3216f43435602ea484bb3d8f"
    sha256 cellar: :any,                 big_sur:      "4c696d7911ab9321c26df52208dd433824e855f50b7a019018c980771c53b5ba"
    sha256 cellar: :any,                 catalina:     "e32b24f59e07ceaac9482a1e1e961f4a0713ff045958e2d5f41872899f6bb4b8"
    sha256 cellar: :any,                 mojave:       "6353572f45ee221eea411c12fb1ba1deeb24b9eea1cf8b15e860886012a000c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dbca3533de2b20945032d022e7776713db26f21d0c94d3ed8c8b355868cefd07"
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
