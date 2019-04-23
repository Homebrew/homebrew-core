class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.8.1.tar.gz"
  sha256 "2e2e263b05e5f551c1a85e6fc5e1f14eab4e742478cd2b0edd57ab17895c2c8c"

  bottle do
    sha256 "c5bd1cb0551f81c23693841fe8829bf9b9e8e6100e18772678bb48a940e70324" => :mojave
    sha256 "4ba4e902f4e4c12754b472ea9b9256cb9c1fe5bd0c96d75c1d4bf67345d161ca" => :high_sierra
    sha256 "9f50b48ebc05a72a64a88c440fc851ece5ccdc7e9f79d378e46673da985d3879" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  def install
    ENV.cxx11

    # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
    system "cmake", ".", "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework",
                         *std_cmake_args
    system "make", "install"
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
                    "-std=c++11", "-o", "test"
    system "./test"
  end
end
