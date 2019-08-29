class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.6.1.tar.gz"
  sha256 "1d82b334114d8784a455fc3d33d3a5860101a4a05a93c79b35cc752509234458"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "d6b1630d919df9541664187c54a148ff4a8d640c23653120b6cd908e95bede21" => :mojave
    sha256 "a9d31a6513dd07e2b4b3eb6e4c1e41abbdb467b7f483b6b7f148998e38a3bb46" => :high_sierra
    sha256 "78d1f5026a925941754369270931e38a3a3a0b7c1b1b404b5df53fa3a6bc8410" => :sierra
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
