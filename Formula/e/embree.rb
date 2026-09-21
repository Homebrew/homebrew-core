class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://www.embree.org/"
  url "https://github.com/RenderKit/embree/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "dcf338cc61b636c871ccf370e673bfd380c5ecb71ce49ad50f28e1d4ec9995dc"
  license "Apache-2.0"
  head "https://github.com/RenderKit/embree.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2d8e8c2a85a2603616b2acd3e5fbd6c662a57df9c330b5afc7ff2864193cdd3e"
    sha256 cellar: :any, arm64_tahoe:       "599121dbb13ec24262aa0f1ee733d79f13dab88df48ab4179652ae0de7ef326e"
    sha256 cellar: :any, arm64_sequoia:     "a08f58e85ee4281a712fe8e0b553e30b2a3eb1dac6a7e70955b5daee18256f20"
    sha256 cellar: :any, arm64_sonoma:      "68776f6b9992f0315f0bc13c2bdf5c6278b8c29c78157aa1d732fa4cee1e5184"
    sha256 cellar: :any, arm64_linux:       "33418e0762947304108496847bd0e54fb9c7f4832e2afbf0c7563c5123d4fe2f"
    sha256 cellar: :any, x86_64_linux:      "b2d4cb849835178c2cee7847c8115c0305be7a8ed6956ca6a56f612ce77ba231"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    # Enable maximum ISA as it is detected at runtime
    ENV.runtime_cpu_detection
    max_isa = Hardware::CPU.intel? ? "AVX512" : "NEON2X"
    args = %W[
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_TUTORIALS=OFF
      -DEMBREE_MAX_ISA=#{max_isa}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <embree4/rtcore.h>

      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree4"
    assert_match "Embree Ray Tracing Kernels #{version} ()", shell_output("./a.out")
  end
end
