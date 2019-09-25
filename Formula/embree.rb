class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.6.1.tar.gz"
  sha256 "1d82b334114d8784a455fc3d33d3a5860101a4a05a93c79b35cc752509234458"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "628e4aec747ce33affd67c642de43247d8493248ea62dadabf3bf885ce4c4276" => :mojave
    sha256 "ddd80cae937699a608b1ead4715f23b6ddab06e12d24b19510cac2a23945e01b" => :high_sierra
    sha256 "fb337abbd7e2b57f6ecb839b22e59634a7b370273962eca3631f51385d17d01d" => :sierra
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
