class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.12.2.tar.gz"
  sha256 "db1b3ef888d37f0dbc567bc291ab2cdb5699172523a58dd5a5fe513ee38f83b0"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_monterey: "4245d78eb8ab8d1cb9076aea319b2abbaf5ec281beeb29dcce97c7b275ace9a4"
    sha256                               arm64_big_sur:  "b49272a8d5e6ff5d4c0fcf1bb093bb7f0f54d30e4d25ee318ef1197b24c4ff76"
    sha256                               monterey:       "0f9e46a30937b313b1417838c55d6bb316851184cc3522ffd24fa11d423f703f"
    sha256                               big_sur:        "7f09cd46fec546f218154533070b9ea3028dff5d19d830a1518fa9a93286360d"
    sha256                               catalina:       "f67f712e843a6cfb7a3c4b77d91c8c16f9988e1a155e3d6493635934ed76f195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa25072ff1e7da1807a4861360fde7a69ebd08843b2862fd17dcd238fbf99f80"
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

  on_linux do
    depends_on "gcc"
  end

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
                    "-std=c++14", "-o", "test"
    system "./test"
  end
end
