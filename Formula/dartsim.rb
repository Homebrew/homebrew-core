class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.12.2.tar.gz"
  sha256 "db1b3ef888d37f0dbc567bc291ab2cdb5699172523a58dd5a5fe513ee38f83b0"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "eb6259f4a573e4166a88961bc76bf7b56730538cf1c193de7075d5e6ba5b76a3"
    sha256                               arm64_monterey: "e5de7bd2b3c5527e461e4eeaf8f3e78846b51136316dd965254c46b7d9c61b19"
    sha256                               arm64_big_sur:  "32f47556d7768bf110b4942aa807b37fd75ed15e316efdec2a3b9f3abbc6ac25"
    sha256                               ventura:        "bcbde8e2a2029ad3d3b0fc96fc6c863b8cd86d3ba83c3ff26be835ce4349ed1d"
    sha256                               monterey:       "24300e8d8f39767443f6fd3d8d660de38ed322bf95a008128b05d6f29390101f"
    sha256                               big_sur:        "431876c374f8a29b5bbd360d8783cb238631c6fbc9a0067bde5d8f3248b6bbc1"
    sha256                               catalina:       "e7a647c4fa42791c5cfe1b563fb1e1fc49eee5d34cf5dba5e98636a3d76e5147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09834b6e3f3c4f58e56a625ecf3b3093930f051169e6d2dd3a4bcd51e19959f4"
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
