class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.54.1.tar.gz"
  sha256 "0aac1c8ebaf87a989507ba1dd374ab7cdecedb792a692b5c3aadb1b7e61b585e"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3da026909a9e5342bd220bcc821e7a27de5532d1a7b00273477432127ac71034"
    sha256 cellar: :any,                 arm64_monterey: "8746d3998a4630961c787631f6edb9c9a253f70c2f77c8a6516d3b0f8cfbacd1"
    sha256 cellar: :any,                 arm64_big_sur:  "e35ed2d31500e525e282243ce831a5d6aa0f791c950d2d4b8a6843246222ba7e"
    sha256 cellar: :any,                 ventura:        "6a6c09ca98f61e319fb9bc9e872beda72950b419402615908084d6136cbf9857"
    sha256 cellar: :any,                 monterey:       "6fda7bbf1f0d1ddd3676f212a2edc0752e8d69cfb6acf0ab1285d629c7cd1de5"
    sha256 cellar: :any,                 big_sur:        "c14da9dd55dc8a09e19195570bce2e487516fc9c5302740ce68c2f55d0641e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5823c24b3474daee78ad3039c881102da9d549f3de096c3efedec458f75c5d15"
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
