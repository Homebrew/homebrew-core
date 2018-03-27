class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.4.0.tar.gz"
  sha256 "7a9e6e081d1cb910a7c9c996d76dd48ddca15b798c6d9a3cc7664534e5d28a84"

  bottle do
    sha256 "1dae19e0ce324f008231e77072a5341d5a56bdd4c697358681320b8d9f440206" => :high_sierra
    sha256 "7ac3fdbebd53601acb3c3d13ea3e5c6c55e77c8957700bf3834eab414cfc21d2" => :sierra
    sha256 "392a649584943cea24e14984dec90208fd0ba8532b3f800981b8eae7b887831c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "freeglut"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
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
                    "-lassimp", "-lboost_system", "-std=c++11", "-o", "test"
    system "./test"
  end
end
