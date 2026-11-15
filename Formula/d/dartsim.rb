class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.20.3.tar.gz"
  sha256 "da78699a52468ac0931a4e03026ad2ff8a6bb03da99a23ba3fa2f7c58ee85538"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_golden_gate: "38dbfba70bb139ce1b26840e90904bd953f7833d4217f7107bb0980dbd65d83a"
    sha256               arm64_tahoe:       "f11493ba4bccffaa0a9b12cde633ebe3abefc45c63113a076b34fb2f4dde1614"
    sha256               arm64_sequoia:     "d63295e6a8c354a4f995d727b895947aed3a119868eeba1bfcb5e9d6a8d670b0"
    sha256               arm64_linux:       "28eb081ce7c20f762ebc43693ad117b96ae56716167ddcfe703773a0dfbcd349"
    sha256 cellar: :any, x86_64_linux:      "e38969f68227b72927ecf11bc493621287a9ed982ea1a16751cda1951d41316a"
  end

  depends_on "cmake" => [:build, :test]
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

  # Keep DART's bundled ImGui compatibility patches without downloading during CMake.
  resource "imgui" do
    url "https://github.com/ocornut/imgui/archive/refs/tags/v1.92.8.tar.gz"
    sha256 "fecb33d33930e12ff53a34064e9d3a06c8f7c3e04408f14cd36c80e3faac863b"

    livecheck do
      url "https://raw.githubusercontent.com/dartsim/dart/refs/tags/v#{LATEST_VERSION}/dart/gui/imgui/CMakeLists.txt"
      regex(/set\(IMGUI_TARGET_VERSION\s+"v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  def install
    resource("imgui").stage buildpath/"imgui"

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
      -DFETCHCONTENT_SOURCE_DIR_DART_IMGUI=#{buildpath}/imgui
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
    (testpath/"CMakeLists.txt").write <<-CMAKE
      cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)
      find_package(DART QUIET REQUIRED CONFIG)
      add_executable(test_cmake test.cpp)
      target_link_libraries(test_cmake dart)
    CMAKE
    system ENV.cxx, "test.cpp", "-I#{formula_opt_include("eigen")}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{formula_opt_lib("assimp")}", "-lassimp",
                    "-L#{formula_opt_lib("libccd")}", "-lccd",
                    "-L#{formula_opt_lib("fcl")}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "build/test_cmake"
  end
end
