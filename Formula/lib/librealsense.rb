class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/realsenseai/librealsense"
  url "https://github.com/realsenseai/librealsense/archive/refs/tags/v2.59.2.tar.gz"
  sha256 "a41a1533795c582ea12ba652ac6fe7cb97eed08fe9c91ba4fefed5bc044bc88c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/realsenseai/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a6495f8932eee2712d7476c894e6cc245ab16c79c48837e7b4e82feaf9f918f"
    sha256 cellar: :any, arm64_tahoe:       "f05dcc00148f5cf7a5c9db9684272d71b3691cb47e7608778c73663f7f2749ac"
    sha256 cellar: :any, arm64_sequoia:     "69a3fd8b5f56abb4dda234f842b872a70db9f17ab986e7813a0f68ca0424d630"
    sha256 cellar: :any, arm64_linux:       "70fdb9234e65aebfa7ca5307bd38ed51da90ac376c592e8466b33ad46a67d3a8"
    sha256 cellar: :any, x86_64_linux:      "d3497952f29c627365a7e452d14fc6721d0397d0642ea2071c642b436276ec0d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glfw"
  depends_on "libusb"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "systemd"
  end

  def install
    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCHECK_FOR_UPDATES=OFF
      -DENABLE_AI_ASSISTANT=OFF
      -DENABLE_STATS=OFF
    ]

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
