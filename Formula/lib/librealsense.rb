class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/realsenseai/librealsense"
  url "https://github.com/realsenseai/librealsense/archive/refs/tags/v2.59.1.tar.gz"
  sha256 "8de92d31412c272b62fc14b830bb17e5c16d6adda6d1c156009ebdfb4aa02f20"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/realsenseai/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "45e4dce261bdb612fe6fe9b8823113e877301191fd948c0edf04a05edd453a9c"
    sha256 cellar: :any, arm64_tahoe:       "57fc4e872d3f24b250eaa59affbe27e2e6b7ce49ca53971ae3be8d2fd6a0776f"
    sha256 cellar: :any, arm64_sequoia:     "7ebb20dd5d8aba1a1d4dc233608c899fe8faaed59262a78d40d66229fda60f07"
    sha256 cellar: :any, arm64_linux:       "4b1a1c0766ce44e6e205d55bd85eaa34fc79a652272e927e63b90d1580dc371d"
    sha256 cellar: :any, x86_64_linux:      "a8d5812ff6d0ff70f76fea6ef240166e2ad36e8b86f721f1282188c5c095b02b"
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
