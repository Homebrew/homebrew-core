class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "55974e650d9b78989ee55adb81cffd8c6e39ce5d3cf0a3b3198c522bf36f6e81"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cb94bb7a2fc99013ebdce7544aa87136149bc69fce5cb0fe1b8838788f672c4c"
    sha256 cellar: :any, arm64_monterey: "f606fa09b7f0d87d95bec188727b7bd058373e726527d5d5a06a3dff132c160e"
    sha256 cellar: :any, arm64_big_sur:  "474b623582aa113ad7fce11aaf505bae0acf9a2a47e92560e94fd7ab2b8803c2"
    sha256 cellar: :any, ventura:        "3a9e0d4a366aece63173b15d5a172a32577bca88d376deb44b66ff23e4355841"
    sha256 cellar: :any, monterey:       "394583d69bea8efcd6eaa991b1a8c31e1b51bd691e7634bd7e5dace7a17680a8"
    sha256 cellar: :any, big_sur:        "6bb8ebb044c15a0dc5cad82c3f97bff0c7d36537bb46c7fc326e874e5d5fe8fd"
    sha256 cellar: :any, catalina:       "91a644692ca74faa2a124c6a32c6d09a1fa0c57dd86043c2bb438722b8b556b4"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.11.0.tar.gz"
    sha256 "9cfeedaccdefbdcf23c465cb1e6c02057100c4a1a573672dc6cfea5348cedfdd"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v1.3.2.tar.gz"
    sha256 "7704736566bf17497a3e51c067bd575316895fda96eccc682dae4aac7fb07b28"

    # Fix CMake install location.
    # Remove when https://github.com/openvkl/openvkl/pull/18 is merged.
    patch do
      url "https://github.com/openvkl/openvkl/commit/67fcc3f8c34cf1fc7983b1acc4752eb9e2cfe769.patch?full_index=1"
      sha256 "f68aa633772153ec13c597de2328e1a3f2d64e0bcfd15dc374378d0e1b1383ee"
    end
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
