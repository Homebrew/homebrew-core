class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v4.0.1.tar.gz"
  sha256 "1fa3982fa3531f1b6e81f19e6028ae8a62b466597f150b853440fe35ef7c6c06"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d286384529b74c5f76c315370a958d9b620a1988d5792eaa42a25afa04b62bb"
    sha256 cellar: :any,                 arm64_monterey: "a9a933e23a99f06a9801606fe590a885fc4a8f3b94bcaee39bddfb8f642b1f43"
    sha256 cellar: :any,                 arm64_big_sur:  "c34012a71735e3c74a471a7b663fbc48a89975c002b3611606c403adbff6c715"
    sha256 cellar: :any,                 ventura:        "e914825520760206a839a4dffac63512602d5885d652d50f5810512d790c7db6"
    sha256 cellar: :any,                 monterey:       "604d5050a0fa7f47b1b8149c0f80212a1bb36621abf56e491729ea36623f60f2"
    sha256 cellar: :any,                 big_sur:        "66f75b4f486c4d8afe91ee87ced611e373b01f7652e51aacba11903b44fec5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbde01042832114be21228702964d9976fcd363065cf355f64bc4858e1b40a0"
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
