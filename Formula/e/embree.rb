class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "baf0a57a45837fc055ba828a139467bce0bc0c6a9a5f2dccb05163d012c12308"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c81da27b990edcb75559c5c3cc7a9a55aa3657dd2636ca468ba1bea7738d10d"
    sha256 cellar: :any,                 arm64_ventura:  "26e35493e331c1fb6642eced1480be13f6df5972d0a54e0a5a023fa39bd15246"
    sha256 cellar: :any,                 arm64_monterey: "898b8dc0b774034ca8efc9c28346d2db99e9981bc4845587f32753e1b4242e56"
    sha256 cellar: :any,                 sonoma:         "382ba33536595a64cf4de63c63d2f36c5db72a8cabfb51806a35c045121c454c"
    sha256 cellar: :any,                 ventura:        "bae17abc1ad0114e3c74ff3470bfeeb65e3e357ba20a8bd509c034517aca6cfc"
    sha256 cellar: :any,                 monterey:       "34c18fc1abb110f62becd196f3c6dad1c67a64c781b6c3849fed4c5025ac78a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc182160dd2cf64ed03e45f3d9915545427903fd1ac271177eb9986934e1d1b"
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
    if Hardware::CPU.intel?
      max_isa = if OS.mac? && MacOS.version.requires_sse4?
        "SSE4.2"
      else
        "SSE2"
      end
      args << "-DEMBREE_MAX_ISA=#{max_isa}"
    end

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
      #include <embree4/rtcore.h>
      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree4"
    system "./a.out"
  end
end
