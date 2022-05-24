class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.12.1.tar.gz"
  sha256 "e0d47bbc191903b93474da00bbd1042cefdc85f5ead3e9a9282b5f4187d53304"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256                               arm64_monterey: "78c5bd771e55e9a9f695c9d84cbde3d29cf98695dc4838d3dc8f4b7d3389cae2"
    sha256                               arm64_big_sur:  "2e3f397fd9b6966f30d8df1102e0018fb0045dbb4c769092cbe8ac29303ac75f"
    sha256                               monterey:       "79b267ca710dbb94391f2b9c1a148b3158dbec4a2b4f7a4ff304c360cee2d6b2"
    sha256                               big_sur:        "32448a13ed1f2c60bbec9189a120c54b21e8e32610b1a0b27cb501d7f0a2e9d9"
    sha256                               catalina:       "7cb7b52b029d78e7a15fb6e34af0a6ef31acda6e0f84b0d1b8e6956b7c610b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c33344ecc0a935febd41cd29dac43af7790d9ebe0165d0e5952a4559a72705"
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
