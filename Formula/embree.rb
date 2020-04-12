class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.9.0.tar.gz"
  sha256 "53855e2ceb639289b20448ae9deab991151aa5f0bc7f9cc02f2af4dd6199d5d1"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "eeadbb69a2e0439b9c2d67391dec7ceefc77de75ed0535ec49af93d8ed8c41aa" => :catalina
    sha256 "fd0ce3dbe8248f382168ce9bccf6d31145de02ee062f333cba5eb6a966f4d532" => :mojave
    sha256 "5a5641cf4b93a026bc362ba695a5b92788c92ed975222959797c697e20a8be16" => :high_sierra
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
