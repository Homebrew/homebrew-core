class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.5.0.tar.gz"
  sha256 "b4c7f4d800ae5696e6ada04bd91b299f4a5e4ff9e8e07deeed79c6923747e274"

  bottle do
    sha256 "a0a44990bd96b2e408b2410b128919733fdba1966562b3fa7aed15eec73d09d6" => :high_sierra
    sha256 "ca6ca866d2158fcbe371f997d9257a1a6336ab3d8ec93fe26f3d9e52b0ebf92b" => :sierra
    sha256 "dd250b9e71156da434f950963b63be79febb88fa30cb382543cc32edf3649ff9" => :el_capitan
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
