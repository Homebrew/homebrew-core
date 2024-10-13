class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.14.5.tar.gz"
  sha256 "eb89cc01f4f48c399b055d462d8ecd2a3f846f825a35ffc67f259186b362e136"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sequoia:  "324071ed085c1271aadf3888188dbc191ffddf7826dcba046cde62852a079818"
    sha256                               arm64_sonoma:   "c678fa87d190dce71e5ec19caeb042172a4c1eefd6312814942381a907d8015f"
    sha256                               arm64_ventura:  "8df0a41bfac187753b2d80c375fb40f8b9a95362a5ed2748184e27ffe0d38bc2"
    sha256                               arm64_monterey: "8d33767ef55aab5b8c02a41ffa78a720b99e5bfc4dfec20bd7de3afd6635e93c"
    sha256                               sonoma:         "d19c0f8573569a152c5471758cdaac3250879ded991bef01cb6db03fc512e41b"
    sha256                               ventura:        "17bb38e1f132ebf5a05dc2a12e73d649d7cf598b46c03c0f8d544fba97e9d825"
    sha256                               monterey:       "f53b33790e3b73a7f272bac4074eb0a1f77d65e3d312764fe5891263c79373e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdb43f54568034d5f8ae62e172a11102b6147c877ad430b986a74fb8a1db990"
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
