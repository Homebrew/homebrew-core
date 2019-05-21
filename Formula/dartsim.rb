class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.8.1.tar.gz"
  sha256 "2e2e263b05e5f551c1a85e6fc5e1f14eab4e742478cd2b0edd57ab17895c2c8c"
  revision 1

  bottle do
    sha256 "863d050a31aa011c648f4ae04e39ec261f5086ed6d99a408f50d5773e7e9cfec" => :mojave
    sha256 "3110c47576b9bbde2b50d72cd8325697763cd8ba08e82b86366ff663b0ed80bb" => :high_sierra
    sha256 "38f55a29c44f8b80301f772abdc0093a71af28c3b69394328c143acc9b4a4fae" => :sierra
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
