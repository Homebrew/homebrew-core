class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.11.0.tar.gz"
  sha256 "2ccc365c00af4389aecc928135270aba7488e761c09d7ebbf1bf3e62731b147d"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "c2314a12cbbdf6719d2273059abadfe6011f9d687846fff186d1e9936f3835fc" => :catalina
    sha256 "98e880b02ee28bf5f7b30d5f1490e8675c00a868a4fe2f7cf3ccdc663b93a613" => :mojave
    sha256 "2c9d9b8609732beaf03fd4eece181dbea33d2f11325f7062657be84db8ba8dfd" => :high_sierra
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
