class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.13.0.tar.gz"
  sha256 "4da3ff8cee056252a558b05625a5ff29b21e71f2995e6d7f789abbf6261895f7"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "5c1b642d9daafedea6fbbb06e32f4b688d033e1dd3f09b8c6f40d74ce66cec62"
    sha256                               arm64_monterey: "30f5c2fdb095ed02e74b7a5fe148b774c93ddaa0d8f3e98bbb3f46b6df619e4e"
    sha256                               arm64_big_sur:  "89516e71417c7dc1f4d45ed3da2b2e7c33155c153f55e84080149a9913006295"
    sha256                               ventura:        "c4b9322ce64c7e40d6184190f68543a7f5d6f5fc74d63daf9340e89828f8fd22"
    sha256                               monterey:       "e24c5af19d241e32b97bf11201e273c42a6e4517f0b99cceb7b4c9ce34916fa7"
    sha256                               big_sur:        "e45c5cb8c8d9647c4fc9db4f5fd011220a4d24a66af12ef3509c636851782ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd27d030ae70b16aff2df1c7a8d56042c893f6b07d049be8b480cada84ddf44"
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
