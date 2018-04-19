class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.4.0.tar.gz"
  sha256 "7a9e6e081d1cb910a7c9c996d76dd48ddca15b798c6d9a3cc7664534e5d28a84"
  revision 2

  bottle do
    sha256 "ba22d7c91a38221a5c3e0237c42ddd2af044eb3e96222bb6f8402033eadc4e5e" => :high_sierra
    sha256 "48025d5e1a006dfb5e1772a25d931b5cf50c8f3dd58d665c3d01f8b2169a7ff4" => :sierra
    sha256 "af0cfdad029623574519c5eaaf503a5c5e39148ac29806e57fd784ae787b72ff" => :el_capitan
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
