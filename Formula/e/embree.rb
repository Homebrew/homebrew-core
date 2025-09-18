class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://www.embree.org/"
  url "https://github.com/RenderKit/embree/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "acb517b0ea0f4b442235d5331b69f96192c28da6aca5d5dde0cbe40799638d5c"
  license "Apache-2.0"
  head "https://github.com/RenderKit/embree.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "477cda992cef4fe35ae37f58b67e7f89e209f7250cb2b89f5902ded3b0008af0"
    sha256 cellar: :any,                 arm64_sequoia: "0e14c51f653cf499ed565097f3b56f5d6574e957e30acb98b96640d3108264cc"
    sha256 cellar: :any,                 arm64_sonoma:  "891dc250e01999638fca1cd3bf3d91d68e3cce51a53b69365e5cba84dd308088"
    sha256 cellar: :any,                 arm64_ventura: "5bf98a0ad31110da963f9fa7990a80aa03fe3c143b2e3cf7b26a5f8941f89957"
    sha256 cellar: :any,                 sonoma:        "a4ba2a8ec5a66658c2bceded9220f7f9bfc9463d1f91975c83e5b755e460253e"
    sha256 cellar: :any,                 ventura:       "08e013fc481c2bf81a3575d717e8b742087d3aab92420555f7e02373db8686bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e942582ec7b5bb15689e9d283d9715d58bb38036f41a9d640177bde320934e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b45c3faa9543e9a30ee49a55e65acf115ff544b04f837f273afc39341c64566"
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
