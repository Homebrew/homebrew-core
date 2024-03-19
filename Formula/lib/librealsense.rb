class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.54.2.tar.gz"
  sha256 "e3a767337ff40ae41000049a490ab84bd70b00cbfef65e8cdbadf17fd2e1e5a8"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aebf37517c1a6bc7dae701192b36de341b559c53bb85c7a5695ef19b3b5cc65e"
    sha256 cellar: :any,                 arm64_ventura:  "9f955d14fcb0d79627d48da3dfcdfdf03c78f2cbd132be4692da0c79c4390b1e"
    sha256 cellar: :any,                 arm64_monterey: "3b3cc58c022a43966cb827fb6f92fb03b796f37b58816a441bdf8719aad817e8"
    sha256 cellar: :any,                 sonoma:         "373c14b5583a15000057f0ab07f6a1edf1f840de55d8726c2303c3bf85527134"
    sha256 cellar: :any,                 ventura:        "10a00df2c5344880eb0ed6afeecc9e8760186406ad0c487e9b268530d4995606"
    sha256 cellar: :any,                 monterey:       "50e4fadd295fd432e3d18052b5d6225f05121144961b13a870c991d5cd6666a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8cb66d686b24fb241ba698ce4635b002199ddf28dbc7cee575fcb4195e4687"
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
