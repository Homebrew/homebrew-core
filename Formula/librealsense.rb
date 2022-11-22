class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.51.1.tar.gz"
  sha256 "f03b2bf6d52c665120dd0b961fe4553867c2a6eddb5d1898e123f9eb81a91536"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bda1a332d872471b28aff793771c3fc0f727ceb24473a8e23a64abb29397b8cd"
    sha256 cellar: :any,                 arm64_monterey: "558c77261f81f424939e36841e79c8eb236711468434bca6be72987312e7e550"
    sha256 cellar: :any,                 arm64_big_sur:  "6b62d2e23da3c9ea8d43e574500d57ae1608d0c31ccbd982d5bd2080d2d94d6e"
    sha256 cellar: :any,                 ventura:        "b5f0271aaa73d40b99625e399aadc5ea8d7174bd3ebc560df7d3ff5ca6a0006b"
    sha256 cellar: :any,                 monterey:       "cc5fbbc7f972a475548615cd0a74fcf84a61d91093f2efb8c3f74ca5097c7ea7"
    sha256 cellar: :any,                 big_sur:        "9ed5a2e0127f3cd378fbc624a32899dd0fbe9162c50f675699225e4fc5066d60"
    sha256 cellar: :any,                 catalina:       "81d5784b88e8609b49432b3acfcdcd5cc7185447738c601fc0ec8be719681829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21f823c8d286e304e8de0b3767ba270daa1e05e2c8ada7e65bc6d9c5278dba1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"
  depends_on "openssl@1.1"
  # Build on Apple Silicon fails when generating Unix Makefiles.
  # Ref: https://github.com/IntelRealSense/librealsense/issues/8090
  on_arm do
    depends_on xcode: :build
  end

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
