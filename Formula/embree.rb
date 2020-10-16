class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.12.1.tar.gz"
  sha256 "0c9e760b06e178197dd29c9a54f08ff7b184b0487b5ba8b8be058e219e23336e"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "24dd899fecc29d3dae947fa89e73e55d74613446a917b8859275532bc0678608" => :catalina
    sha256 "76d3ae888b4d6ea0a411d1596b6e3df5b1ab3f545ce4c617905c90895baa13d8" => :mojave
    sha256 "ceb906540e0219a32fa3ea0a22d581293e16d6cac55b385165bdb15518cef757" => :high_sierra
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
