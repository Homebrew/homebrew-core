class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.48.0.tar.gz"
  sha256 "7eda3332f793c0290d95453e805df81e6ef1ed28e3b3f7d1e274e9901f9ca906"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "874d8bb2d532562ba525f7106820b2a69f87ba126ad0d50094a188f2410da5b9"
    sha256 cellar: :any,                 catalina:     "2f6a598c960c718439c072014109c5edd93b83c09f42c97d56004a2a5f83ff19"
    sha256 cellar: :any,                 mojave:       "24524f8069fc972b315914863f0e0b69213a9d10738cf8053a15141ac815b85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4bc7c17e2157c00183c06fa8ebce53e44a00332d6dbab7b570516340ab647acb"
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
