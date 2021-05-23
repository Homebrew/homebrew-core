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
    sha256 cellar: :any, big_sur:  "6b30a204b4d29c01d6298ee85b7cc16d8946339c33644f75548e1fe51aac04d5"
    sha256 cellar: :any, catalina: "99b50658b861665891450b4e35edf27c222ca8b0b1aea90fdcbbfa072c4c05f4"
    sha256 cellar: :any, mojave:   "4c690975e60499ab1aa895b032bd3d3a46f7c8d100193d7f9081d760fd83a738"
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
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
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
