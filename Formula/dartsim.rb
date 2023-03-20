class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.13.0.tar.gz"
  sha256 "4da3ff8cee056252a558b05625a5ff29b21e71f2995e6d7f789abbf6261895f7"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256                               arm64_ventura:  "55c146a0dd1ce842b59e1f7a054d349220f14444313257b24be156f3dedddc4e"
    sha256                               arm64_monterey: "bc17ff9b3a90355537e826774d7edf5fe155f4d624377baec3cbe0fa867d10a9"
    sha256                               arm64_big_sur:  "01b8afa4280a8583c4e2a07bd121494d249da65bdbf69d0bb18d5e81c69825df"
    sha256                               ventura:        "70119711d6dd50cfdb88abd6601aeadeaa85b1d8f867ba46ff167748ec209276"
    sha256                               monterey:       "88f4a74a68fafd990a61fd65d5b274c3212a220c35b98e5771b66cbe3af3f6c0"
    sha256                               big_sur:        "a8f245344c5b81dc0f70be0333e8f7a97bb9759f59c150806fc34100630fc673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e462d8e551b6ccdf90605c39d59a3d5fb2d941034abac46264a1b2328ba3b267"
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
