class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.12.2.tar.gz"
  sha256 "22a527622497e07970e733f753cc9c10b2bd82c3b17964e4f71a5fd2cdfca210"
  license "Apache-2.0"
  revision 1
  head "https://github.com/embree/embree.git"

  bottle do
    sha256 cellar: :any, big_sur:  "92af3a0076df1a0b4a29da93fd5668dc775ccdc2e3fc664f0209ebfb714ffa5a"
    sha256 cellar: :any, catalina: "5541e440ebb20f060178115d0e89c54c903d0bf497b2cd87ba9bf9b53ddf72f0"
    sha256 cellar: :any, mojave:   "dba82e9b00a329f86d4fb37ac220d3b1f7e36cf102a292b082638a88a3a92146"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    max_isa = MacOS.version.requires_sse42? ? "SSE4.2" : "SSE2"

    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_MAX_ISA=#{max_isa}
      -DEMBREE_TUTORIALS=OFF
    ]

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
