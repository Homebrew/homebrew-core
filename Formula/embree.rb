class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.7.0.tar.gz"
  sha256 "2b6300ebe30bb3d2c6e5f23112b4e21a25a384a49c5e3c35440aa6f3c8d9fe84"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "e18860a08289bcef0e093c9dda4a4ffbbc123f3f14395cc941cdc69c01bce9ef" => :catalina
    sha256 "8faa655d40472ea2c3d3fb0cee30629df5654afb2f32c5a7ac81b48907a149f1" => :mojave
    sha256 "d6553bdd4020aedb7af7f11009bae10de51f4522d19932d1c93abd9505ff9497" => :high_sierra
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
