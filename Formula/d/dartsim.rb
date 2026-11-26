class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/refs/tags/v6.20.3.tar.gz"
  sha256 "da78699a52468ac0931a4e03026ad2ff8a6bb03da99a23ba3fa2f7c58ee85538"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b9373cfbe2564a1bd0f55f29868f03822cc6131566fd31583c9faade2c85d434"
    sha256               arm64_golden_gate: "ae5242fbd96634989b657511c859ddc4f932bca2cfae075c8cdbb6524e732e74"
    sha256               arm64_tahoe:       "5a8ee29bd5999f529cba4929c6efe342d58c12b6a16fcee6ad75106d8b8e40a0"
    sha256               arm64_sequoia:     "46ff954f3555a3c094d606938ba319bd5d021cc9098e1f7862dcfd82bb753c33"
    sha256               arm64_linux:       "21667456fd45c36ac8e83bb0e02d06e821925b813302328ec10fd2a22aa7b6bd"
    sha256 cellar: :any, x86_64_linux:      "e48d19338d17f86c712c1aba9cf42a50e3c65188aff34e1f7beb64f2dc5a44b8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen" => :no_linkage
  depends_on "fcl"
  depends_on "fmt"
  depends_on "libccd"
  depends_on "octomap"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog" => :no_linkage
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

    # FIXME: octomap 2 only accepts 2.0.x version requests, so drop the 1.9.7 minimum until DART supports octomap 2
    inreplace "cmake/DARTFindoctomap.cmake", "find_package(octomap 1.9.7 ", "find_package(octomap "

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
      -DFETCHCONTENT_SOURCE_DIR_DART_IMGUI=#{buildpath}/imgui
    ]

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
