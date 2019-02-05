class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.18.0.tar.gz"
  sha256 "e9ff4c56e00e4bd423a272e2a5750b277f2de630f0ad07bf1d04a9e2a36df5fe"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "a7a70a732fa9ed9217c5422d7f9c9c6169e4d5b8ebb2bb84cec3b4412efd3070" => :mojave
    sha256 "04f4510f41b5c0a030d37c2cab1aa363041105dda0f56e951810b37a6b9300d1" => :high_sierra
    sha256 "de4a5d1bf80cd189d1b93a927ec65a8466f123d57261caa1f728fbd842cd73de" => :sierra
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
