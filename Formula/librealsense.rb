class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.50.0.tar.gz"
  sha256 "cafeb2ed1efe5f42c4bd874296ce2860c7eebd15a9ce771f94580e0d0622098d"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b23a09d176e9fac673c1ed48874c80394bb5c4cd4ae751757dbce5c20e32625f"
    sha256 cellar: :any,                 arm64_big_sur:  "df9542f991b62d5905bb85b8409f8fcaf81a9e30e111e3b1bae907d14797d078"
    sha256 cellar: :any,                 monterey:       "c4a501d50abf2287d7700ede8ab2cd8602d2a71ab138e8b98c1ac0c244e843a5"
    sha256 cellar: :any,                 big_sur:        "a0c555c2884007c2441f6d25a3ec4661a80c6ccebeff8e6972ad1d1e4236ef16"
    sha256 cellar: :any,                 catalina:       "8fcbda6676b9df6401b14b02d6862eecdf8e931afe1cfb8f3bae2d5399c6e79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af90eea1b514759bda89c478b9aa77fde8502ae1095b5e64b26c8db17e137e5e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  # Build on Apple Silicon fails when generating Unix Makefiles.
  # Ref: https://github.com/IntelRealSense/librealsense/issues/8090
  depends_on xcode: :build if Hardware::CPU.arm?
  depends_on "glfw"
  depends_on "libusb"
  depends_on "openssl@1.1"

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@1.1"].prefix

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if Hardware::CPU.arm?
      args << "-DCMAKE_CONFIGURATION_TYPES=Release"
      args << "-GXcode"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
