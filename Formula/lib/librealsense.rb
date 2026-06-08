class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.58.1.tar.gz"
  sha256 "14409c3b810bf1508b87f46d47608a89018743b8a73d5855ab5d1ad18763fd8c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c4d794f26976a966926005f03ad74f057e401d11a4d6dee78f6744539839710"
    sha256 cellar: :any,                 arm64_sequoia: "bce8442051cdcf8d918bf361bcfb0021c1f8682c4a8fe9bec0bde9086989b233"
    sha256 cellar: :any,                 arm64_sonoma:  "3fe96b1aa8adb7f0317bad5c6152ea3c990f6da8560778596d7f91345f10820b"
    sha256 cellar: :any,                 sonoma:        "fed4f0dcd5656e8f63f6924baa82df424d6135a6910783d24cc715eaa4867b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a28593638cf8040e82c23a9a59e3cc3e99fbd69e30cda17ae898a98da9dde9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae00b77402699f25c89d7c8494476d0891746fb4b5fcc85be1f544e100f96a8c"
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
