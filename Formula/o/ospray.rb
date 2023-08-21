class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "268b16952b2dd44da2a1e40d2065c960bc2442dd09b63ace8b65d3408f596301"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6f5fecb1c05c875d50e53dafd400703614e36839614b86261bdb98ac3e38d823"
    sha256 cellar: :any, arm64_monterey: "3e0664c0b539c4f47c2b42706fee64d32c14cac1241de144e8d114f3f72a35cf"
    sha256 cellar: :any, arm64_big_sur:  "7a24a8a3c4c554d02b59d03b9d7751d6448173a762d3ae8ed4b06c11126204bb"
    sha256 cellar: :any, ventura:        "90e4b25add8ab1ce3ca89279244b1c6253014fc70e038adbb4f73a8a59a8ff35"
    sha256 cellar: :any, monterey:       "7f2130305e1c5f3a86a8cba185e8d5f203f306fb678476eb3022db59bb48c949"
    sha256 cellar: :any, big_sur:        "30ea6004307fb11e32af4bc28e20332e7d6d1c53dcf001f500552fc5c685fb2b"
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
