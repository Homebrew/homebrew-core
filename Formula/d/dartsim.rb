class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.13.2.tar.gz"
  sha256 "02699a8f807276231c80ffc5dbc3f66dc1c3612364340c91bcad63a837c01576"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "620a4b776dec5fe6ef3800df2fb48dccf0ac178e5ec044226637c10fef8641a3"
    sha256                               arm64_ventura:  "813dd6ca1b037b5602a7f7d9c1e41c0230f3df3c31ecafe8777851b42eb1e91b"
    sha256                               arm64_monterey: "e849dfdc72a4b2f22d89288f5da2d484fb777091e27954845f1fdd6f8e0c713a"
    sha256                               sonoma:         "7008565b462e4525c2a38eb12a40316518a0e6838155f36835c739c47cecdb8d"
    sha256                               ventura:        "404d478630fc46753f8daf210e815ef993ad6201288731731e1f05bbd0f67ea4"
    sha256                               monterey:       "a95c468a2704adf99ee3e8fb403b3f5d9979a4e50033c32e88bb67f76ee27432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda106259c407fe62ece832afb42451c90bebea0fa408363c53ebcd5c722f555"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11
    args = std_cmake_args

    if OS.mac?
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
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
