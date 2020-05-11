class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.10.0.tar.gz"
  sha256 "7af744b2c3a2f60aa54cdfcf7928c56f59aabec4a7310dbb96b09a6c64a5a7b0"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "d3af66c824bcdf6f41d071ab0ba85fcd25c7c47a93ec486d2c786a9c4b5ad259" => :catalina
    sha256 "af00b9ecf7ee6413524396682bf1c5c9277139ac9a040ef6ff8616d2db99ea99" => :mojave
    sha256 "0a18aacad8ec4a9c1bc4c84fd8427375266e8f514d69ebea067bae0a12b7d9df" => :high_sierra
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
