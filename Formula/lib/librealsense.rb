class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/realsenseai/librealsense"
  url "https://github.com/realsenseai/librealsense/archive/refs/tags/v2.58.3.tar.gz"
  sha256 "6a4c59180950bd9ced58a3dfc4ded586ed22dfc9c418684e7fc8c241b9aaac98"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/realsenseai/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "250ac1ad17d86f20936fa2aee03035548c8829a319c0df2d87f45306ca8af021"
    sha256 cellar: :any, arm64_sequoia: "376f074eb8939e4411c5a417957fca18af19e3a0269bfeb525725134b2e2a2e2"
    sha256 cellar: :any, arm64_sonoma:  "9c9e383b31f46f34bcf61dd8e1554883ecf549a258618c084aa9e9c8a613eb7b"
    sha256 cellar: :any, sonoma:        "49572be2ea0f9f267c3a80f68b4eba3b41e415c3b053ba3488ea86ca499f14a4"
    sha256 cellar: :any, arm64_linux:   "437a29ad820c61db8f01661d4612343c8e480815a23f4fbe2f41ce75fed82615"
    sha256 cellar: :any, x86_64_linux:  "0e7e4ee20a15c40669fcabe70fb5eacc1aac703f4725f96b659251cfff12f290"
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
