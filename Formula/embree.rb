class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.13.3.tar.gz"
  sha256 "74ec785afb8f14d28ea5e0773544572c8df2e899caccdfc88509f1bfff58716f"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "688baaeb72504ff7d2f19e048121b805a8701e057942696f3323ede58aecf01b"
    sha256 cellar: :any, arm64_big_sur:  "b845757ab2344160dc54d336c14b2ffe80d3cc05a0b0a296ecf808be24fdb22d"
    sha256 cellar: :any, monterey:       "c53fb56c890319718fbaf5c6c805fb14aff2a7338aa02f23f4e6a4b3e9e3c23b"
    sha256 cellar: :any, big_sur:        "bbdc3c8818dc11b86bfdc97f7bd3f6e660673ab783cecee96bbed102820f9615"
    sha256 cellar: :any, catalina:       "8810f5e20f5cdd151889ed43942c26a73be528ab0b181a6a3a21c3aac017ba99"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    args = std_cmake_args + %w[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_TUTORIALS=OFF
    ]
    args << "-DEMBREE_MAX_ISA=#{MacOS.version.requires_sse42? ? "SSE4.2" : "SSE2"}" if Hardware::CPU.intel?

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
