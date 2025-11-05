class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "bbf954e283f464f6d0a8a5ab43ce92fd49ced357ccdd986c7cb4c29152df8692"
  license "BSD-2-Clause"
  revision 7

  bottle do
    sha256                               arm64_tahoe:   "1920dc73653aeb057dcf27644f2ec2b57749ee6c9d2328733712cd0876d4df98"
    sha256                               arm64_sequoia: "512ffe161072bb701ec6ed1e939a6a0d0491d935bf4ac052581244536e6dbafd"
    sha256                               arm64_sonoma:  "0f4b0b2c0c2cee8f18a90256f92c5b0ab9fb3c6b892523ed81e3c010f4230681"
    sha256                               sonoma:        "8350a51f816311c2176eba807319e59be607f54aa6ed8a9dd9bddc69e9893f58"
    sha256                               arm64_linux:   "b40c3209d705b7b5c0ea8de6f0110603c4d58e3cecba626d552ffb60134c2894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1eb956106ba43d5d4bf5428d9dd93d27a68a3006536e0efae5a7703dbf032c6"
  end

  depends_on "cmake" => :build
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

  patch do
    # Fix for finding eigen 5.0
    url "https://github.com/dartsim/dart/commit/bb558d1a0cfe06d9d7a9da1061b42bcd5411ab83.patch?full_index=1"
    sha256 "9e10dbeb0be4a0454c05ab5adf4a3b5e095e503acef20188da59456ee1244748"
  end

  patch do
    # Fix for compilation error related to asserts
    url "https://github.com/dartsim/dart/commit/bc2e99b19c5a0609d1091b1b7667f6f1a2a3bb9b.patch?full_index=1"
    sha256 "60154cf3211d499731fd47b8fcf74dba398dbbbee23d1445fc919acd54e25df7"
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
      find_package(DART QUIET REQUIRED)
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
