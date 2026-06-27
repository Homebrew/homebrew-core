class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.58.2.tar.gz"
  sha256 "1e164e424b4eeb207ec05caecc6fadc1f3ecdce0d6d36f0f2e4fe6a2a9b423ab"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "709cdc56e5de484c73854bd44f6af61abf2efc43a9992dd595bd371441c9bbad"
    sha256 cellar: :any, arm64_sequoia: "481bb874039210fcc14c649423596677ae51d2b18a3ee46b841b7236cda625ba"
    sha256 cellar: :any, arm64_sonoma:  "d8b8fd7790f0bbdd7c64fe59275d4f6c31511235769a87079ea3cf68db615a7d"
    sha256 cellar: :any, sonoma:        "b5810d547153cbd46eae5750207ab3cb70425928edb2e90eaa6021a67c7785e7"
    sha256 cellar: :any, arm64_linux:   "1dd23b89c3818c7d11f744a38fdddf44b61fa439f4a0087e1c13d1ba67fabec8"
    sha256 cellar: :any, x86_64_linux:  "1424ca38a899811163f2248523d33c3c6c6464a747f89772d151e8d589d91182"
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
