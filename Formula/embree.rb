class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.13.2.tar.gz"
  sha256 "dcda827e5b7a606c29d00c1339f1ef00f7fa6867346bc46a2318e8f0a601c6f9"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f528ba35b704466b1e7b1fa48dc57b5a248403228211959e23f0dfd8a6754beb"
    sha256 cellar: :any, arm64_big_sur:  "d1369defe4bc281212e5383b64f9e4709a4d775e001320897dd166470619311f"
    sha256 cellar: :any, monterey:       "ace87ceb8f083acf8e7444301954b7fdd8723e06f51287e1d5e0732a5bb0c9b2"
    sha256 cellar: :any, big_sur:        "fac38a131c9f2eae86d240e8a9d3ce104b356da4beabba06b7f98e7ff9bb24ad"
    sha256 cellar: :any, catalina:       "3a696ad83e6b9df39438f19ee8c439cefda5ba0204c3e293fb8522911bb07c39"
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
