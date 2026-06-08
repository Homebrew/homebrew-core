class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.18.0.tar.gz"
  sha256 "7439168bf2aec62d5c76cdfa58ed1327e65ce5f5407e912ddcc1557276695e02"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "01397a678ed0c1c6dd18a312ba9c9e003f1d2f2ae889f42f97ae9e7ec3b77f33"
    sha256               arm64_sequoia: "26a319d0a2d6dd9be5e0e2f777c5c6e790213b2c99be01800556c1a31cff08d9"
    sha256               arm64_sonoma:  "ea59275236e8343d36e0563b1a4d6faced515cfd6499d044e54c0b5135c609f6"
    sha256               sonoma:        "5c7e2ad898ef4492b5bccfa46ef51107e4c59590d8a87924f2d2b40ee57f4311"
    sha256               arm64_linux:   "db73a29938c71eba623f94d9087c90928f71d7eac59c04eeab63e7cd244adedc"
    sha256 cellar: :any, x86_64_linux:  "35b761fcad122502c19296f80132477bafaa4a277db13336bfe84ca25305e4cc"
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
