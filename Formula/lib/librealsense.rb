class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.7.tar.gz"
  sha256 "02eae8aa49d52d39ea5483836116fee2596e1146254274db6b76d7a62092d9e8"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba740c06638228e96a74553a83e9ab3b861ed5dce1c869befeabc0c05b956f18"
    sha256 cellar: :any,                 arm64_sequoia: "8f9b88eb42c685a7d1cbd615263c8bd22fd7aa2869090bf6c1ed407b4b6b9fc1"
    sha256 cellar: :any,                 arm64_sonoma:  "219961d51d65f252e6f436ae6b6ee6005083d1ea1686b3774416fb6e968c3ddc"
    sha256 cellar: :any,                 sonoma:        "7fb045dc094cae4e538727955c725c950257b39ab721f856914b791d306c17dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6cb411e5b83e2546f995da168cc081c5ad7dedaa1431a928520853b1019e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b894ff145cb546fa7904714bf115039ad373397e081d6e23daa07480c13837c1"
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
