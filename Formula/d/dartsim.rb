class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "bbf954e283f464f6d0a8a5ab43ce92fd49ced357ccdd986c7cb4c29152df8692"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sequoia: "e535ad930fe32671752d6857924a7027a23b05c226d095adb2d3d090ebd6c40a"
    sha256                               arm64_sonoma:  "2cfcce63b8f5efa854cf20e196a686b7d87efca67e17b436c2fac235b38a0ba9"
    sha256                               arm64_ventura: "3c65ad8471fb493c412874b423fbd039ceda631dd6ab823b49c4e002e7ed20a6"
    sha256                               sonoma:        "b62650e04e8d7938d63435472dc998ee188f5c0bd9e42d9cb0e77a1fe02e2c46"
    sha256                               ventura:       "082d4233b947f2f43ef6232a62b531eea36c1e5484aca42d145ef5a74ac9373b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8f7901d2a25186e278030991f26c028aa3b62fe8cdefee42398b2480319774"
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
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
