class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.3.0.tar.gz"
  sha256 "aa92634c1c97d99966cf16c4a0845792941358c063409fa00c28b4039c961c25"
  revision 3

  bottle do
    sha256 "1d42c8518e5ca9b1e3385dda95714e4c0dc1d4cee75eeae1c2a690a071080faf" => :high_sierra
    sha256 "fb766a0cee1b88a16b80f2b67358b4b2d0725f7b91aa3f3c5602f4286369a4d0" => :sierra
    sha256 "89a67a8591a588303491191c793ec61bc9aabea1ffe79a8ed0eca0a34cef7b91" => :el_capitan
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
