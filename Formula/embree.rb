class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.12.1.tar.gz"
  sha256 "0c9e760b06e178197dd29c9a54f08ff7b184b0487b5ba8b8be058e219e23336e"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "a7d59835dda29e4659392ed9d4fed84d61c03b22eaf77492467c491d575c417b" => :big_sur
    sha256 "003fdcefa1da6372c782345e295b2188686adb6f7ccadee2f00d15a58b41ef85" => :catalina
    sha256 "6f347831ed4b4dfa51b88af83c71d9a6c1f7b62775a033a672b1461029f84842" => :mojave
    sha256 "766356663e8c1970c121c68faec10c8fd2323fbb128c392927a24c3961e20c5f" => :high_sierra
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
