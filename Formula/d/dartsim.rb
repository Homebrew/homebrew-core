class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.16.4.tar.gz"
  sha256 "d7af169aca40f63e8fae0541421bdbf48a36bcc5e236414d0d3ae2bf4eada489"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "b77593b5691a14dad76cefbbc7bcac4f608c4259d141f627be7da1a111d513ba"
    sha256                               arm64_sequoia: "f6707064e571b71a4fe294df2f72464dd9466426b3da402bc3c1e6013ef391d8"
    sha256                               arm64_sonoma:  "e5980510acc5ce5981e4db57db0ec5077b2cd15df71029820836c8e3dbad7f01"
    sha256                               sonoma:        "64f2a972730b9c5e87485cdbe30db111be7c0c9ea258cf6110de2b14ad1cbab2"
    sha256                               arm64_linux:   "ef4ba9a4e34b17a206956a1b5626252cc0fa2517912c10590ce51ae2f3c29b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cea62167bc447f0de48491936fa62056e6bc66e95935640772632f14d0f9a30"
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
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
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
