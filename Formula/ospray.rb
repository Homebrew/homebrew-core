class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.7.0.tar.gz"
  sha256 "bcaeb221b5dd383d27587ffaca7f75d7e0064f64017a0d73df90862b14b5704b"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "753c0bf558ec8b7d3205414c2c95b653bdb36dcfe14642d3146b24096a59602e"
    sha256 cellar: :any, big_sur:       "0aa7486d46be69f2398f546d33a692e287d5dbe7d3eee09d4da91184ecb6c757"
    sha256 cellar: :any, catalina:      "9472ab24b5e62fea698b80b16ee48e5f06aad31684328f1d7d7510db0e44ac2e"
    sha256 cellar: :any, mojave:        "1bc2fa3d7012ffc3360aa95bf018dde3a5bc478245071189330ba109553b62e5"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.7.0.tar.gz"
    sha256 "b24d063541ccbfd69e6d77485b509d1bbffd9744e735dbd9bd8647eb8751c5b7"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v1.0.0.tar.gz"
    sha256 "81ccae679bfa2feefc4d4b1ce72bcd242ba34d2618fbb418a1c2a05d640d16b4"
  end

  def install
    resources.each do |r|
      r.stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args,
                                "-DCMAKE_INSTALL_NAME_DIR=#{lib}",
                                "-DBUILD_EXAMPLES=OFF"
          system "make"
          system "make", "install"
        end
      end
    end

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
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
