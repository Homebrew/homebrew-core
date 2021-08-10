class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.47.0.tar.gz"
  sha256 "00767dbc888bc3495aa8f38ec372231bb2c198efb003db3e86af6d2e5458d1bb"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "772af31ed7ece7e5abdb68aa8a18842c24b84cc06dabbe9fe25339061d2be518"
    sha256 cellar: :any,                 catalina:     "e5b7df3a87c3339afcef582068b34bc5137723411eaa60551cc894c90f969d01"
    sha256 cellar: :any,                 mojave:       "4b1baf8d93909a9ccd6753f7841ee9ea7966fb7def138941749fcc6ded3ae818"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d1ecd25f823fa158ef11208bd2d5d13aab184617bc2947c1f0e343031535e571"
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
