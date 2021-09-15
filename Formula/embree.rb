class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.13.1.tar.gz"
  sha256 "00dbd852f19ae2b95f5106dd055ca4b304486436ced0ccf842aec4e38a4df425"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "618f2d211c581ee8c0337dfb554d90b8e6bcc9a093cd7bf933a5aad2fa0f3fc6"
    sha256 cellar: :any, big_sur:       "7d6e076f06d7d4dccc270b6ed0b7934c4c6e4e9ec4f37fbb25c8e3bdb94b47a6"
    sha256 cellar: :any, catalina:      "6fe1fb72840fad50ed356c6280407c1a52b59155f7edd0fb84d796ece25bbd1a"
    sha256 cellar: :any, mojave:        "99d6e36d2d7188389648304719e7ab94a0f3cae719ed0b6a43bad4c6e0615de2"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    args = std_cmake_args + %w[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_TUTORIALS=OFF
    ]
    args << "-DEMBREE_MAX_ISA=#{MacOS.version.requires_sse42? ? "SSE4.2" : "SSE2"}" if Hardware::CPU.intel?

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    # Remove bin/models directory and the resultant empty bin directory since
    # tutorials are not enabled.
    rm_rf bin
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <embree3/rtcore.h>
      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree3"
    system "./a.out"
  end
end
