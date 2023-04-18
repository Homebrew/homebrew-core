class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.53.1.tar.gz"
  sha256 "e09d0cca0316fa02427ce749c4e9cc8d34e3a86c127b32a8dca3ef483e71e908"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63acb7654c7db630c266278643994b0c52e1875ea5bf19c5f070c034771adb82"
    sha256 cellar: :any,                 arm64_monterey: "1ccd5104fd3002c39e5e77f7705a1c0d5d79d2c62b9f41abc3dc9ee3f1138d8a"
    sha256 cellar: :any,                 arm64_big_sur:  "ce9813788b2d4951aea45f0a36c4b4e05b38b8aacd4490d7084810e3422ad58b"
    sha256 cellar: :any,                 ventura:        "99d687e21915dc577d6a9c4738e7bcbd242202dfeaf5de9a17552a11e7c1321d"
    sha256 cellar: :any,                 monterey:       "109c4c5fec1b2f67faf9ae852602f02601213bb99a70c21e7c36913f02f3fc69"
    sha256 cellar: :any,                 big_sur:        "c0a48855fc7ed376a0bfb471a89bf05164acfcd22db193c250c7d0778ede1b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1046ae2d7f16707ab59ecd204401c01e05ccbbf1301028cd115c245123d9a4a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"
  depends_on "openssl@3"
  # Build on Apple Silicon fails when generating Unix Makefiles.
  # Ref: https://github.com/IntelRealSense/librealsense/issues/8090
  on_arm do
    depends_on xcode: :build
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix

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
