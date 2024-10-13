class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://www.embree.org/"
  url "https://github.com/RenderKit/embree/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "8a3bc3c3e21aa209d9861a28f8ba93b2f82ed0dc93341dddac09f1f03c36ef2d"
  license "Apache-2.0"
  head "https://github.com/RenderKit/embree.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2ce8bbb8db418a1db7568e8608497e5df8fad482df2c8daa1cd20ccf01fd1589"
    sha256 cellar: :any,                 arm64_sonoma:   "719d672a8f015eb72d2227a1cf2c28345591976abcbd8a3d096f45318d7edca1"
    sha256 cellar: :any,                 arm64_ventura:  "2968f35c23daf66b3e6afc07bee6cf68829b3285f1e29dc098b0ace335851711"
    sha256 cellar: :any,                 arm64_monterey: "c39c1dd2e9dc0cf439a7df98dd74df9c0b86808300a1a44ccc45fefb4b2d88c4"
    sha256 cellar: :any,                 sonoma:         "ad297f96354b4f7b33a061495b43637f266ad025305a9cccc64b3fbdbd062c56"
    sha256 cellar: :any,                 ventura:        "61379810c6582eff76eb3b5d6c62008b1315326f8ab0c4b7a9bd893b55c006b5"
    sha256 cellar: :any,                 monterey:       "2df23844ea00a109fa15abd46077164d6ff93c6d1fdfebe6632c16703085423d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85eb36f2191fc119f3cb5c0811fdb50d59e045b148f67d5e6c6fc849a1519eaf"
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
