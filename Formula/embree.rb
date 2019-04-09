class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.5.0.tar.gz"
  sha256 "4635439c277d0f688f1a21ad13ad22fdadbcbca04680cce346c88179b9522741"
  head "https://github.com/embree/embree.git"
  revision 1

  bottle do
    cellar :any
    sha256 "a7d16ef5e33ac78f62f9b23242ae55cbcbad67bb2c89497dfe0b642c81fea90d" => :mojave
    sha256 "49c69c87a8edb993da30effc53aacbb5c3b65732db4e90b3d5a30faadfa257a0" => :high_sierra
    sha256 "d88a33be1de06beaae5bdb702505f643667444f7527286373be1d04cc54c9a97" => :sierra
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
