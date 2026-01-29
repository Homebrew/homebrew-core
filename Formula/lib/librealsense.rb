class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.6.tar.gz"
  sha256 "4c5eeafe004422e564df4ba74cab0e89a4b32282d0e0d6c1e9b33382bb5ed767"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bc396096eaa6a8b001b905f7325e4f2750f97043e8c1dc885e628e4a3873fc0"
    sha256 cellar: :any,                 arm64_sequoia: "25c13fca0e51b4523ae358d160cf8c27a505139134d3ab67a786238528c54166"
    sha256 cellar: :any,                 arm64_sonoma:  "c17826d2538ec08cc6b01d4bbe6c85212d8f485bf66d939ec3c844a580669f3b"
    sha256 cellar: :any,                 sonoma:        "63f4234403292e53fe885771f70a0cf2be7708acc136ab42f26950ebfffeb546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad99a7fb88f1223e519f622604a9ccf2f439e2c30707160df1dcb9e493fc9744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7590c965420c397348a2a5780972c9409b175e0b2df7b61f7b86c6b25d86e95f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glfw"
  depends_on "libusb"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix if OS.linux?

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCHECK_FOR_UPDATES=false" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
