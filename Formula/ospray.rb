class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v1.8.4.tar.gz"
  sha256 "36527eb01a09b0f30608550373aa305ecbfa2faea23cd929cc731af5864ca326"
  head "https://github.com/ospray/ospray.git"

  bottle do
    cellar :any
    sha256 "19a2a2c636c07427b7d6bdff6d771e571bfa6d8dbf926695932e8cadf60d65fc" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on :macos => :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  def install
    args = std_cmake_args + %w[
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
