class Flecs < Formula
  desc "Fast entity component system for C & C++"
  homepage "https://www.flecs.dev"
  url "https://github.com/SanderMertens/flecs/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "29ccf56961b7ffbd38cce2227a06c0722c7df464422e86619a65ee37bb31bae7"
  license "MIT"
  head "https://github.com/SanderMertens/flecs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff3072358d9b3dd138b664c538ef4e9ba0079a46a48cf701bccb7d43222b2dcc"
    sha256 cellar: :any, arm64_sequoia: "69ab4a56cd892d2741b1522f1208a14808bcd350424a994dce38bc60f916349d"
    sha256 cellar: :any, arm64_sonoma:  "a86f72a1a82c9a6bc9f09abc8d6d95d4da8437bc4282d9cbe507437cfafe3c4f"
    sha256 cellar: :any, sonoma:        "7c1a948ae4396736a9ec9dbc12d1807a6e4b71d4596b9f47c66cae70dfe7969e"
    sha256 cellar: :any, arm64_linux:   "7a36d4e90582f7ed5106ddd56f2662cfd3bd158ad3f03647cc3492df4334f3a8"
    sha256 cellar: :any, x86_64_linux:  "50ba973b76ba09922735c6ed903f5f93326dae73c2112dd62cce5d0543b84a23"
  end

  depends_on "cmake" => [:build, :test]

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
