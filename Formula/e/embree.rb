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
    sha256 cellar: :any,                 arm64_tahoe:   "fb11b4f0806271a15840fa9f2c9c4bdebd7de5d7acf31995b964aae38d03c201"
    sha256 cellar: :any,                 arm64_sequoia: "e34162275529cba08ace54afcfb988b9297794f5aa6ce9559b37e1aeb6cd938f"
    sha256 cellar: :any,                 arm64_sonoma:  "34dace02f56e7424677e8a037e6ff8952a35d8e5624a17e1c52fe421bb6e03d1"
    sha256 cellar: :any,                 sonoma:        "22617ba4d4b95d85a6dda3f3d5a6970c78d1a56974a123319048484fcda2c55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b764ddec2965dbff1e317dee360d30daac5cf76244b788fbbe4159ba6182f3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f3059841dfcb2bc51a8dc92d93edeeb7ad19dbdfa2f10aa663dd89280a6656"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    args = %w[
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_TUTORIALS=OFF
    ]
    if Hardware::CPU.intel?
      max_isa = if OS.mac? && MacOS.version.requires_sse4?
        "SSE4.2"
      else
        "SSE2"
      end
      args << "-DEMBREE_MAX_ISA=#{max_isa}"
    end

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
