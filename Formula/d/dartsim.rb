class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.19.4.tar.gz"
  sha256 "627a6d21650427da634503829eba6c0c20887cd3441082eb44187fb3f9250150"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "f63057be0ef688c2d1eb482a39aa4f1a4e05cb1709c0d167ef8ecaa3f97c2293"
    sha256               arm64_sequoia: "776e505b28c9bac1ae279cd6098e99a6c5a802eb5ec2c84b6b459840d6dc07d1"
    sha256               arm64_sonoma:  "5bb7f57da268c37c6051d3a870b2bd2d0c439ba0c5aa8c553d4b588bcc585445"
    sha256               sonoma:        "15ef52ed76a01bdb93383be08334b329484af03a709820ef54a27a99daaa9ce5"
    sha256               arm64_linux:   "ac94c358317cd1172ab84b97b48247a1a2833a676308a6a195c9680edc6da6d6"
    sha256 cellar: :any, x86_64_linux:  "772da48e17dfcb714fbe921a120e6493b4b61766d5e24d8f20e977c63e0989b4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "octomap"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
    ]

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    CPP
    (testpath/"CMakeLists.txt").write <<-CMAKE
      cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)
      find_package(DART QUIET REQUIRED CONFIG)
      add_executable(test_cmake test.cpp)
      target_link_libraries(test_cmake dart)
    CMAKE
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{formula_opt_lib("assimp")}", "-lassimp",
                    "-L#{formula_opt_lib("libccd")}", "-lccd",
                    "-L#{formula_opt_lib("fcl")}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
    # build with cmake
    mkdir "build" do
      system "cmake", ".."
      system "make"
      system "./test_cmake"
    end
  end
end
