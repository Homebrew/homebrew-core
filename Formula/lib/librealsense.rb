class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/realsenseai/librealsense"
  url "https://github.com/realsenseai/librealsense/archive/refs/tags/v2.58.4.tar.gz"
  sha256 "3d07cafd0fc5c1b1803e1f6418cf7375a387593e873d3897015b8ec94be20e74"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/realsenseai/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19fa059dce95643fc1a4668e10af3ae36d5f4ef8e1a8b22fb6fe845160728705"
    sha256 cellar: :any, arm64_tahoe:       "4f4d32f8c1abceec20572815431c5eb47ec54609b3a1f0c20b4e82384af16155"
    sha256 cellar: :any, arm64_sequoia:     "aa3272699b5bab7785d425e6be9adabf752d694c896afa236af68fb27272e06d"
    sha256 cellar: :any, arm64_sonoma:      "6951671a63b605bc77dbf6919caed8c54d50fc025433406f1235dd4bc0fb9917"
    sha256 cellar: :any, arm64_linux:       "915a2f2c6778431e74394e04f67435c933b987101ffadb46fe556b7a6f95d924"
    sha256 cellar: :any, x86_64_linux:      "4082f7bc9ad49094ece3e3fef2fd023f5b1f296ec32f7943a809ee4e8c8ba29b"
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
