class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.13.2.tar.gz"
  sha256 "02699a8f807276231c80ffc5dbc3f66dc1c3612364340c91bcad63a837c01576"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256                               arm64_sonoma:   "7e58ee7403fa8282bab3d7bcfe4a881b596454b2627fde5debb2140b13a28b2e"
    sha256                               arm64_ventura:  "1d903439ab275b9c45ca9a61e6a552308dfbb1da372255791d365a2b3568e3d4"
    sha256                               arm64_monterey: "dca7316217b4d9d1a8f91f3539cad17341dab3be10cbe79c682b0261b1b728d5"
    sha256                               sonoma:         "42482c0a49e733a42a92f7cf0a983215b7281583998cd9de6645af530dc0824e"
    sha256                               ventura:        "c174550b79bef7c769a9cd841240deb254c3f49067aa217de935a62819898bd4"
    sha256                               monterey:       "6811d8031a242b4041f780f255988b9e9101b433d1a0b67ee88e63ec5d3fe699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a742d85cee365bcbfc461f435b634f788421910baa47fd7b7af53e019c2d44b"
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
