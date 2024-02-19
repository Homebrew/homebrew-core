class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "824edcbb7a8cd393c5bdb7a16738487b21ecc4e1d004ac9f761e934f97bb02a4"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f59edde2dbe52f9e37e8f00f164700e21b7516260c37dd00a30a1f0e791d8714"
    sha256 cellar: :any,                 arm64_ventura:  "3e6831dac7fadc2e65a3570d1c5c8e092ed0613a463b189c1991891369b90c76"
    sha256 cellar: :any,                 arm64_monterey: "35b992ef6d162a1271d621ed5edc429fb292993ed96605936ac682982df332ee"
    sha256 cellar: :any,                 sonoma:         "2f83ac47b08204dd27fc9deec489da48d6ef3c4bb326a5affa6a01fc2eb72738"
    sha256 cellar: :any,                 ventura:        "19bf35024448598f3efc4ee3f055fa123dc7b80997178fbe36f395951579b8f5"
    sha256 cellar: :any,                 monterey:       "70a9be414f42b1ae43560deeb6973c06d34670c6c1bc76d7656c51c6b00fdf8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183323e174eca3b25b65f8dabae19bebb41dd62f52269cdccf09fee81c4d0d08"
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
