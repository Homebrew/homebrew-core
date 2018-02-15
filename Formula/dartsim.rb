class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.3.0.tar.gz"
  sha256 "aa92634c1c97d99966cf16c4a0845792941358c063409fa00c28b4039c961c25"
  revision 1

  bottle do
    sha256 "0b80a62435ed5df93ecebca994ebfdfd3d6962df0f6b9b1ebee8d050c80f7a6d" => :high_sierra
    sha256 "0bdd871592c4425d824c02fc06a4931e246f1bcb39ce85393c4d3ed72fe8e6e9" => :sierra
    sha256 "1e4b48dc6b53a8ef298c8c405010cd1e4c58bc5b171db9b93a2ace3c28f803df" => :el_capitan
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
