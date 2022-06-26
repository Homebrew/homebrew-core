class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.13.4.tar.gz"
  sha256 "e6a8d1d4742f60ae4d936702dd377bc4577a3b034e2909adb2197d0648b1cb35"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "06275ad32b3619e35c82b8dcb824b6a8c723783fc6c9ffd9a3d74a92fae2576c"
    sha256 cellar: :any,                 arm64_big_sur:  "94e0ed11b9f2071699693bbc19f58a029c0946d8b5d6a8f13bc7c5b1d8f18b7d"
    sha256 cellar: :any,                 monterey:       "2229b74e2cea330ac9ffcd12b7b29b6830e5c1aaff85d34a7dfa8831e90bda8d"
    sha256 cellar: :any,                 big_sur:        "a73a36ed7406ceddfd2dadc1e3ae48a19ce495b5a8ae6c71bf1b5e0ec8d81469"
    sha256 cellar: :any,                 catalina:       "8ded60ea5d7a80ddcdd42d9c47a2169a4a072a1b91d82dca05c71cb5d6b20620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354e6fbd80d5ceeb84ebc0ad3fd134e267f752689604e34d51a250d66018acb3"
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
