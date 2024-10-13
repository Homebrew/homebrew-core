class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "cba681c9ff231898ee768bb39d5e5a7bd564289230ca178ae2866ee40f2a3ae9"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a2dda7e92c03482df0406e094a94b99f96de77e39c124225a7ced7b876ca8d28"
    sha256 cellar: :any,                 arm64_sonoma:   "1037b1277c63a562898fc7a2fefcfbd8ad8fdd5200d98b5eb478a4da348c4a95"
    sha256 cellar: :any,                 arm64_ventura:  "624e3f6dc4eb6a706b5eacb7bf70a5ab47c0407f3a23cfdef943f5efbbf49967"
    sha256 cellar: :any,                 arm64_monterey: "2d7233a375e03ac5278aa23031a058d4e4fc4f7d234598856f5c4409dbe0df81"
    sha256 cellar: :any,                 sonoma:         "f180f06532a5c0e3f010b9a41b7e18bd52c53cec7a94107d017a7d00dc6ecb81"
    sha256 cellar: :any,                 ventura:        "1a084f60534bbfa07d8304b3b60a9573ed9b916f72b89da46f7985200bc2e45a"
    sha256 cellar: :any,                 monterey:       "b250539bd6cef09b45d4b7d899bc03efb33c6f3da9db813cd9a91ee747884b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfed498e3435c7586cacb5e0378c09cf7e3671a30131e95b9e016d41aef93de"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
