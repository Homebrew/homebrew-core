class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.7.0.tar.gz"
  sha256 "2b6300ebe30bb3d2c6e5f23112b4e21a25a384a49c5e3c35440aa6f3c8d9fe84"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "dc743cddf5c0a4a1c9f4321913733e2ef771934799b40a2d1898573c2806c3cb" => :catalina
    sha256 "04197610a98ccbe6dabdf09f906585290637d58475be06b4051af9996c3e0437" => :mojave
    sha256 "5aaa55c799cad7f37e58e64743a6f7d105b650bacf80150b4b0b538d1039f2bf" => :high_sierra
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
