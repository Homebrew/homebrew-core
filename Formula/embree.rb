class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.10.0.tar.gz"
  sha256 "f1f7237360165fb8859bf71ee5dd8caec1fe02d4d2f49e89c11d250afa067aff"
  revision 1
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "981361a64119c546e8a151761a323ea61638494c4ff801f591b742eea32ae7a5" => :catalina
    sha256 "4c8749691fc8fc1a0fa255b62dc2a933dde83d8deb240314c3f61bc9eb496372" => :mojave
    sha256 "39ca21605afabf70d60ae9d3f1f720f456f328be2decf3c8e6dbe273beea069d" => :high_sierra
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
