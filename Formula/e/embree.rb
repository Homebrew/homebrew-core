class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://www.embree.org/"
  url "https://github.com/RenderKit/embree/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "dc7bb6bac095b2e7bc64321435acd07c6137d6d60e4b79ec07bb0b215ddf81cb"
  license "Apache-2.0"
  head "https://github.com/RenderKit/embree.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac773161f3b2822c0580db066372b63d518939c55671155bd20c54f16b7fc4f1"
    sha256 cellar: :any,                 arm64_ventura:  "50deea7d486f6c56ff0204e1b33725e659f3fd48520a5408a82c09ca75da0379"
    sha256 cellar: :any,                 arm64_monterey: "a3652817a19d9546c433aed696636672f001ca3bc0e1d04eddf11f3cecdaeb19"
    sha256 cellar: :any,                 sonoma:         "b513021f43c4091e2a74062aea477f96cfc18f42ad069ea894692008da0882d2"
    sha256 cellar: :any,                 ventura:        "2d0c627deb353c1910004ff5c509d10ee8a1090bff875da70b06d4bba7d60ad0"
    sha256 cellar: :any,                 monterey:       "b0b9d01cbaa94d41552a66811150861f71a62f3d587b63e565097389d66d7163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "837fd1ec85bc0c68fb629b2263289d0a6b2eb3a303f868b7b69b7c2c40fecabf"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    args = %w[
      -DBUILD_TESTING=OFF
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

    # Remove bin/models directory and the resultant empty bin directory since
    # tutorials are not enabled.
    rm_rf bin
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <embree4/rtcore.h>

      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree4"
    assert_match "Embree Ray Tracing Kernels #{version} ()", shell_output("./a.out")
  end
end
