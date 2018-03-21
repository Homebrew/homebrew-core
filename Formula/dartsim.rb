class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.3.0.tar.gz"
  sha256 "aa92634c1c97d99966cf16c4a0845792941358c063409fa00c28b4039c961c25"
  revision 3

  bottle do
    sha256 "399ed615995b0d03f4f2bdb09263c8bdbf8d2e8f574c02ae5881997071424c22" => :high_sierra
    sha256 "f191f741b422003ab5d2b4d652d831a1116006a04a7772d5b98ac632e868151a" => :sierra
    sha256 "54ab70495c13b160b20912b3f3e4a44f685c5086b8e1c84db5809bff51168f7a" => :el_capitan
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
  depends_on "tinyxml"
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
                    "-lassimp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
