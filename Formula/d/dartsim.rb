class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.14.4.tar.gz"
  sha256 "f5fc7f5cb1269cc127a1ff69be26247b9f3617ce04ff1c80c0f3f6abc7d9ab70"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sonoma:   "2968a3ebda640c3bd79929c52ba4435528a60cd445c8bc62872ab0faacbad21e"
    sha256                               arm64_ventura:  "da79facaef6b70d098589b22df75a1d3b7d6395663758a1459005e22496c9765"
    sha256                               arm64_monterey: "6e3561edfe03f146623fee343381a328734301d4c905a10b7001359d3d33f14b"
    sha256                               sonoma:         "b2b2317f71a894727f67612166af9c806d476c2b4a3e4f2b22b7e9aa046963aa"
    sha256                               ventura:        "54a488353181fbe09453796c1941967cc4ac7e268e97a116c5108a1582da0a4c"
    sha256                               monterey:       "ee2bcde574495fc446d5320c2ebfbe50a166191ab1f9278723b35d001af2a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6029b69bef9a1a978c9101213b5b076d6c520c68ecc7ebe3763a2c8f9a5840"
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

  fails_with gcc: "5"

  def install
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    args << "-DBUILD_TESTING=OFF"
    args << "-DDART_BUILD_DARTPY=OFF"
    args << "-DDART_ENABLE_SIMD=OFF"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
