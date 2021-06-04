class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.6.0.tar.gz"
  sha256 "5efccd7eff5774b77f8894e68a6b803b535a0d12f32ab49edf13b954e2848f2e"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "2ed4667926055d6b661160fe7730de1843efbf59555af025e4bde3ee5a238315"
    sha256 cellar: :any, catalina: "3abbb9390af9376be58c7356790c505114522b003c492f4ec7e8beb5a70e73cf"
    sha256 cellar: :any, mojave:   "bbe33bc005890bffbdd3ee08c2ae3c2c05c2aca253bc3a7ee2425e09b24f5c5b"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.6.1.tar.gz"
    sha256 "b61c10f26fba3e6f00305d5828b3bac523d559c5c0e6f79893b19e8c0e30074e"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v0.13.0.tar.gz"
    sha256 "974608259e3a5d8e29d2dfe81c6b2b1830aadeb9bbdc87127f3a7c8631e9f1bd"
  end

  def install
    resources.each do |r|
      r.stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args,
                                "-DBUILD_EXAMPLES=OFF",
                                "-DBUILD_TESTING=OFF"
          system "make"
          system "make", "install"
        end
      end
    end

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
