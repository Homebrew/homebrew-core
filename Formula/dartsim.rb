class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.3.0.tar.gz"
  sha256 "aa92634c1c97d99966cf16c4a0845792941358c063409fa00c28b4039c961c25"

  bottle do
    sha256 "54b9b26c143675e40259c47af4d66c38bee44fa86c9fd0ad7dda3b72201dd569" => :high_sierra
    sha256 "3f7fc2621daff5a84443c71348db7e95c9156c4c5775c04f26cc15942072a479" => :sierra
    sha256 "6fcba2b008baa7774f8abebcc5561cfb301434d4cc4d08b88f9396b1e4d52cb5" => :el_capitan
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
