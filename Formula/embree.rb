class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.6.0.tar.gz"
  sha256 "3c179aa09efe1f591f277cd8835e37726998f657730ca456d08f584fc8780559"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "d388abaf0c3db96b55d8e6f55b4d8f41bb697de91944574f0907170793a8b63f" => :mojave
    sha256 "6669bf4407214a4bd1d136df1ce3f3532e719a4b2ab0b2cd0fd5480a66d03114" => :high_sierra
    sha256 "6882def94251b5f64cc4503d71022cad4b79f744abe63e8b65a09fd97b5c042e" => :sierra
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
