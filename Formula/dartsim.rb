class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.10.1.tar.gz"
  sha256 "bf19cdef8e28dbc4059dcbb11997576d6e1d825791bd756e8272d2ddc5b147ce"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "9040d281f8c9b79be449d5a1a675dae00bf0f3aa5c3b2d0378dff33f0e96cc6f"
    sha256 big_sur:       "3f0f960d2f6d85b3c3a77e57bbccf89bc8d45e7a8a20f7a5f3640829213767a1"
    sha256 catalina:      "e0d7a5fca7beef0c9d468061f533c5c496c12853d82781acfe5daa049a80f37c"
    sha256 mojave:        "e282979646c3970e9c29178f33368f8ea60aa0120bff13a14dd99758bfd6a16f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  def install
    ENV.cxx11
    args = std_cmake_args

    on_macos do
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    mkdir "build" do
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
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
                    "-std=c++14", "-o", "test"
    system "./test"
  end
end
