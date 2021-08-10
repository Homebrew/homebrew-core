class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.11.0.tar.gz"
  sha256 "41d783d7f99d7b5ad1874336646f1bdfa33e146e0652a6c32d12eaa21505bd51"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "8e6e1890a93576e5a5da756aaefecdafae8fc628cafa6288c1dccff457ce0883"
    sha256 big_sur:       "6e5fcd1dbc6e054f8add2f4f04a788f39cd6cae0e674dd88ac2613bf23a56c8a"
    sha256 catalina:      "4477ac4f4b5c0d78016e1948bd4476797a5eefe503867fe1c3a2589ebc745c5e"
    sha256 mojave:        "f149e441eab5640abd4f3966aeb0a9857930a3c1b0ffa6d8254f62bc1c329681"
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
