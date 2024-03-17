class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.13.2.tar.gz"
  sha256 "02699a8f807276231c80ffc5dbc3f66dc1c3612364340c91bcad63a837c01576"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sonoma:   "92a1e1472a83abd6b83007dd6a3d7b4514d833aaab447495889f484bfa904e88"
    sha256                               arm64_ventura:  "f7707244487d30886bde0d26b07aa9b789d4cc4f8992351e5e3b4c84b999e709"
    sha256                               arm64_monterey: "027f346e433241969067494ae0b746a27b8ebbf62568e4b99160718b25d5310d"
    sha256                               sonoma:         "1ac1b8cf587e4bafdf92c182faa45f9ade3a657f65810742f04cb75ca42feb65"
    sha256                               ventura:        "d234878f0b625c4b8f3da1bcac92a91f29dd80235e81a52fe485466e2d53306a"
    sha256                               monterey:       "18678581a549e1e74fed53d5e4ddf76429d859eb4efea35973d5523d3fed17bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a32775382aedc46a0bd140e48e46bcdc928b77b662bcefba3ea0077c167e5a"
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
