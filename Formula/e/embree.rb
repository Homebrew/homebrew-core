class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v4.2.0.tar.gz"
  sha256 "b0479ce688045d17aa63ce6223c84b1cdb5edbf00d7eda71c06b7e64e21f53a0"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "400566b352562f855cb387c447a9f3dd2dce9d4d7c69d0b3cf120d4a9978dcae"
    sha256 cellar: :any,                 arm64_monterey: "702e00a4f67ee2f30e7f1555930360a99673a018fa2197b3d8176f56dd872d44"
    sha256 cellar: :any,                 arm64_big_sur:  "c30366d0ec2670988b0c50f61948a2a466c2ad46540081460a06a28d8f5758bd"
    sha256 cellar: :any,                 ventura:        "90f8702047d05d140b283dc5cac829b9462dba6e3df246df93c3b47937596d33"
    sha256 cellar: :any,                 monterey:       "dac7d2e35e8dbad6f03c7c0a367f51d0d2fff814a05ff1bb35f265e92964ecb7"
    sha256 cellar: :any,                 big_sur:        "55465c388a10f2656045872a23db59f0370db304619f7d24cdd59388e062d6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86095df11ba35167cec5740a3f701ac7ea2d648fb6c70de10be9dcf48bc7afb1"
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
