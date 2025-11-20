class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.4.tar.gz"
  sha256 "3e82f9b545d9345fd544bb65f8bf7943969fb40bcfc73d983e7c2ffcdc05eaeb"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cb3737668ea614249e798ae9841287ed299b5e35f9fd3bb1588a1706ef3ba3f"
    sha256 cellar: :any,                 arm64_sequoia: "49b10bccc172bbb048fea4fd5240fccd9a3b6ecc9f942b5e85a1010053d97a7f"
    sha256 cellar: :any,                 arm64_sonoma:  "aa5deb9277060b468f7d88539168e7c5807fab67e2306c0ea69ddcee9d960d65"
    sha256 cellar: :any,                 sonoma:        "afa268296650f02f5ab646786dff793636db07b8937fb60b4218af38ac913cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff981602addba1b0ce86498e05b4481b0311df9dbb4b5107167771acfe727ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0e3e72ab0260345a2b8691537a36227d9e41279f75c6030ddede7616f07ab7"
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
