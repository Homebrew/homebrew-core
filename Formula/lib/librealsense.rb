class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.55.1.tar.gz"
  sha256 "54546d834ff5d8b35d9955319ad2e428f6d9ae4c61b932d1bd716ed81ad135f7"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87e280ea3812239dca4ad87a1804ec565c89a85ed7edf284e15ba2532ae5aff8"
    sha256 cellar: :any,                 arm64_ventura:  "76e7a053fbe4db047091da72157e4c2e1e9e5a69b69352ed90e186b5653be4dd"
    sha256 cellar: :any,                 arm64_monterey: "b4ba20552da3fed47851399c0fe0c663d42bd289aea5de83fe4b9e648257e144"
    sha256 cellar: :any,                 sonoma:         "fb49c09f9103faf9d3d301d5275bf6fc0dd58052d3a33d5363522261dbda8d4f"
    sha256 cellar: :any,                 ventura:        "91a2ed66c52d5a267ade16cf701c4b04aa6f8ca17f2ca0995fae7804059cd4b8"
    sha256 cellar: :any,                 monterey:       "c62805b38655234714aa8f8338e97f14afa05aa72299987747a75dd4920c4db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec569b56db3d7ef79f3cad4d09e8975ed91c71ede4a7d2cab225c81a4fca992"
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
