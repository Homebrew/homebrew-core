class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://www.embree.org/"
  url "https://github.com/RenderKit/embree/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "6692fdf2b55831ac58732459443336d709974051d7ec642b3e1fcf06271b5eea"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/RenderKit/embree.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "556634b7a1c648515b02facb99c3801994c44b29cd8afabe6691460459accc10"
    sha256 cellar: :any, arm64_tahoe:       "aa25cece256cb986cc0379ee21c8f47978c99d2ae9bd44a6763eec9ed02ee190"
    sha256 cellar: :any, arm64_sequoia:     "527b0e8608f5fe7fc848776c37282dfd2d3d0576a5be1a029793306976936b69"
    sha256 cellar: :any, arm64_linux:       "4e4fb3ce6d0a332cc693c8281c0c3afd4e803860f7dd1679f0e0a35b6f5d8c62"
    sha256 cellar: :any, x86_64_linux:      "72837df15a7601e719b89a55c9f9f00f42f939f19bf94412b49566b654232eed"
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
