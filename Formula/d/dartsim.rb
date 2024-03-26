class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.13.2.tar.gz"
  sha256 "02699a8f807276231c80ffc5dbc3f66dc1c3612364340c91bcad63a837c01576"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256                               arm64_sonoma:   "10ca5813b09ead455c290e9fd83871dbaffd0de1a34b3f45a104d3d828a0b2cb"
    sha256                               arm64_ventura:  "f8c4d4bbda7602bb7337f081f39ee7ae29c9ea5961108616013a8f802e704ade"
    sha256                               arm64_monterey: "c8f4e0e7991e242d54154c5e0f68b376bc9e3103e97ceaa8e8f37f90cc6470bf"
    sha256                               sonoma:         "760569333de1f0d7cef49fa036bbc124080a4d5d39ad4786464f9dcf0b9a2895"
    sha256                               ventura:        "90df5bb0b62190120498f9043b50fe507ef6d9d42de44202cb7aaeec068577a4"
    sha256                               monterey:       "6487d772bd684936310ea12334d9eda6b9f5bab0976089de0ede4a90c89adb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e973d9bf7aa7779f5bcbb5b29c724bbb01d2ac5b77620c1ec3d11e65d69ddc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    mkdir "build" do
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
