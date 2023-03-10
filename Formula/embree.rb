class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v4.0.1.tar.gz"
  sha256 "1fa3982fa3531f1b6e81f19e6028ae8a62b466597f150b853440fe35ef7c6c06"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25c2267519a75993c6b0435f53a28ddaad3c8e1d36d02b7c14fc24a4ace31487"
    sha256 cellar: :any,                 arm64_monterey: "88bf2039af072c9f650ffb5d2a43c309b1c40c386c71f6ed00eecb82a687ce99"
    sha256 cellar: :any,                 arm64_big_sur:  "0eee015b5c72e005d51a2d5494d764554906334598fb78be9707841142c8a1be"
    sha256 cellar: :any,                 ventura:        "163d14cadb8c1efafe8c280a9d8c1365e61d21372ea86236b6b23c80b21dd223"
    sha256 cellar: :any,                 monterey:       "beca63794b0cb6eefc282ba0604f112b7608dad142c648e948e306f1a1d24241"
    sha256 cellar: :any,                 big_sur:        "efe39d5be89404e6ab2d6cbab82414f30c4c963e55c75eb6defa76508a129e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f8b57e3141a5fe1445f8781692ef1b96f31bef4da609dd34a270a748a2a1f8"
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
