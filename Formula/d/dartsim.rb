class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "bbf954e283f464f6d0a8a5ab43ce92fd49ced357ccdd986c7cb4c29152df8692"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256                               arm64_sequoia: "57838cb631dac3c85c350663acee1b0582481212eac4a029d00792b58da5f814"
    sha256                               arm64_sonoma:  "5b6c0a008105e1a5b1d2d3f0b84dca6505775c363cc0ec7871e06173430da721"
    sha256                               arm64_ventura: "f76dce0bfcfceddd7b0cf4b1d73f283336935870a43d152b49b52a68602dfe8e"
    sha256                               sonoma:        "5ca7f3fce898de34e1dc012ed0aee14a0b870667f03ff190a6856ff834990dc6"
    sha256                               ventura:       "2e3acef9d48405a5ab2a3e3a1df04379774a483cfa20e9d130132da14ab0b083"
    sha256                               arm64_linux:   "386afa41680de20b295b29113e38210427bfccec0702068caaad1e44e57b6429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b659c3c5a28cf073ea7b3ab319f9f2e692de6da6c8aa3869dea0697d2d0ced6c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "octomap"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
    ]

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
