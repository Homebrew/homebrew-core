class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.5.0.tar.gz"
  sha256 "4635439c277d0f688f1a21ad13ad22fdadbcbca04680cce346c88179b9522741"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5c650b947f90c74ef1f465d5b1318b170938d75914c9f96a75653e193a91fca0" => :mojave
    sha256 "099a4840c01f1cca959223d1bf379d0be4d1d63888aa91c569f57e817ef7c070" => :high_sierra
    sha256 "a5e100142f8e373549da7f033f84f089df01031d792648daee532f9697421386" => :sierra
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
