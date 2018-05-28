class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.5.0.tar.gz"
  sha256 "b4c7f4d800ae5696e6ada04bd91b299f4a5e4ff9e8e07deeed79c6923747e274"
  revision 1

  bottle do
    sha256 "9fb1b85db352b77bd956610992d15aeec1342d8a12b0b71382a9d148fade6a4e" => :high_sierra
    sha256 "3d98b89a99627bc3ccc72a91efd52f04ca7a0e2ecb968c6a96f7148e85acc453" => :sierra
    sha256 "4f2f7191199f9e6ef19baf97808a1c4207d7688d3b4bc84e1416aa127a464934" => :el_capitan
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
