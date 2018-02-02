class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.9.1.tar.gz"
  sha256 "9c1698c93de5c695f839bac935baffacf2c9b002fe807de8fbe1f31d39b8d0ac"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "83f3e70454dd4816de36d468312ca8ea8fd03d4593ec3e4c7d92e2148a17daad" => :high_sierra
    sha256 "4d5a673b4c48956d65ab02eafa8ddc5737e0d555962921407029f436b7f9c222" => :sierra
    sha256 "3afa6255b0dbf00043e2ce26461168da8032649fd30d56dfa56c298482456048" => :el_capitan
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
