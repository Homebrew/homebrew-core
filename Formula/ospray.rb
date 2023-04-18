class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "55974e650d9b78989ee55adb81cffd8c6e39ce5d3cf0a3b3198c522bf36f6e81"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "271bbd13d28297c593f6346e0795e828e4ecc5d060d88e254f26c269c5e3f59e"
    sha256 cellar: :any, arm64_monterey: "f96b2d9e1719ddfa603bb6da6d5122d996f31036b052434d99c661d40dd97fc0"
    sha256 cellar: :any, arm64_big_sur:  "8ed29e8893e5920db0bde956c93632a4f7ec2728ed0f9b74d75bdaf63acc5757"
    sha256 cellar: :any, ventura:        "6b84de5b3e90af300eb0e762662a40931ca55ff85da27089777c3bdaa9e8b854"
    sha256 cellar: :any, monterey:       "4ec88dd7164147861cabf33dbd90bc192e442a92e919220c1bac375eee77171a"
    sha256 cellar: :any, big_sur:        "f29c6dbc9834bfa4fd566673b43067359f8e0fba2cec7d3e3b8672b1f615da65"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.11.0.tar.gz"
    sha256 "9cfeedaccdefbdcf23c465cb1e6c02057100c4a1a573672dc6cfea5348cedfdd"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v1.3.2.tar.gz"
    sha256 "7704736566bf17497a3e51c067bd575316895fda96eccc682dae4aac7fb07b28"

    # Fix CMake install location.
    # Remove when https://github.com/openvkl/openvkl/pull/18 is merged.
    patch do
      url "https://github.com/openvkl/openvkl/commit/67fcc3f8c34cf1fc7983b1acc4752eb9e2cfe769.patch?full_index=1"
      sha256 "f68aa633772153ec13c597de2328e1a3f2d64e0bcfd15dc374378d0e1b1383ee"
    end
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
