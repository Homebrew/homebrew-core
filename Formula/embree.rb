class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.13.0.tar.gz"
  sha256 "4d86a69508a7e2eb8710d571096ad024b5174834b84454a8020d3a910af46f4f"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "34ebcc3b29a0d7194d2bd99992e0cdf6a1a65c4359ca069ab2871fd07e91994d"
    sha256 cellar: :any, big_sur:       "ccb92b5bdc9349ea27dce5ca3d7f439e562a005ee8c9156890e9e87527bd945a"
    sha256 cellar: :any, catalina:      "a5018cde142cea96f08ccf89e4b653d3a2cf521c8c884abf10b1e9b176f75dd6"
    sha256 cellar: :any, mojave:        "f31316bbd32d20997392a8bb35d6dfd8e9103e77a46382411d445a92d23f5595"
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
