class Flecs < Formula
  desc "Fast entity component system for C & C++"
  homepage "https://www.flecs.dev"
  url "https://github.com/SanderMertens/flecs/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4107b0a36aa25f80ddcd6f939451ccfe1bacafcccdd2695840a4a8c413d05b40"
  license "MIT"
  head "https://github.com/SanderMertens/flecs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b6b3139b50c2923791debf442e03f5e8e05cb7b98103f65a609774e7e2cb9f03"
    sha256 cellar: :any, arm64_tahoe:       "60d7e71aab61edc9ffa1bbd42fe91485903d39ed5e2911551b56ac5fe89c8114"
    sha256 cellar: :any, arm64_sequoia:     "ee69c0ad9864e7773abfa164c62d1d0ae15ad5c952d61dc8220bdd7508180eef"
    sha256 cellar: :any, arm64_linux:       "924377d3cb006e1b958e1d0c5f9ce65fc818ad96fb55efb2965dedfb0f145e7f"
    sha256 cellar: :any, x86_64_linux:      "1ba10dff84a61f9033f40d0c6e598607d95938db6927b562a6af8bc9f2ad2ad4"
  end

  depends_on "cmake" => [:build, :test]

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "builddir", *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"main.c").write <<~C
      #include <flecs.h>

      int main(void) {
          ecs_world_t *world = ecs_init();
          ecs_fini(world);
          return 0;
      }
    C

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required (VERSION #{Formula["cmake"].version})

      project(test LANGUAGES C)
      set(CMAKE_C_STANDARD 11)

      find_package(flecs CONFIG REQUIRED)
      add_executable(test main.c)
      target_link_libraries(test PRIVATE flecs::flecs)
    CMAKE

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
