class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.13.0.tar.gz"
  sha256 "4da3ff8cee056252a558b05625a5ff29b21e71f2995e6d7f789abbf6261895f7"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "7d87e75c956bd01b0955876774f3579f8a1f71a15443c8da7a40f6f893f7047a"
    sha256                               arm64_monterey: "fde2737c06efc20a8225bc069239c38e8ce9b0d0f1cc714935089752e8053650"
    sha256                               arm64_big_sur:  "9997aad1d52a9e379204b955ca02a870579d99df1968fb9668b6c2100f57e003"
    sha256                               ventura:        "3e1471c57d9bc3b97caa03c540f5f574e5b1929d88550ac14a8167abfad4de6a"
    sha256                               monterey:       "0ea1d2bac05caac08af8b1c27f626a7c84a44ff1ce0c8d151417560ed842b6ae"
    sha256                               big_sur:        "e884f32d4b70d5295cb9ec0cd627ad7e56f1dcedc486f7475bec1f8937b45084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d90b429eb15a69f777c6977a9b175a73698aa95f7c2b62cbfbc996ba5937e2c"
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
