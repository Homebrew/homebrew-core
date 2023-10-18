class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.13.0.tar.gz"
  sha256 "4da3ff8cee056252a558b05625a5ff29b21e71f2995e6d7f789abbf6261895f7"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256                               arm64_sonoma:   "057b3d77110a53561641a9b9c78948b10a6f9a283446716cdb0a33613b4ef810"
    sha256                               arm64_ventura:  "68675cf8db94036f1759ac9ad3019b6a0fe394c523c9260a7bd13d9b402aacf8"
    sha256                               arm64_monterey: "b3e480184cb8fb5b46ffac522b873b6b422fa69656ef1a1ca55cdbec332227e3"
    sha256                               arm64_big_sur:  "09b51aeae04c3893ed2e4c1b87df87a43db8c4549f47818eaa35ad59cc0dfd7f"
    sha256                               sonoma:         "ad02237982c8fbc58b36c8128ff4e0ef99512f7a063d43b850a7fb0c1a39f596"
    sha256                               ventura:        "7a790bf5d140b1b02cdd6e7992679fb44fdbe74c821f44cfc0d6aff958108460"
    sha256                               monterey:       "aafcc389c3beae33d95c8dc13e6998036c3796fea8560ef7d4a0d7cfd4f7e845"
    sha256                               big_sur:        "b4730cb15e677393a1305f5a60b1d170b7a26de1aeb55039cbbe348dcbac60da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9441cfaecbf9bcb2ed95c7d2f68d594cd81236fb07ac921c624a664cd58014a"
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
