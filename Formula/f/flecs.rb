class Flecs < Formula
  desc "Fast entity component system for C & C++"
  homepage "https://www.flecs.dev"
  url "https://github.com/SanderMertens/flecs/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "8b94f56dfdda0b3c86110f651a4e0ec1c59030db43bb4810ae296a0630682ab9"
  license "MIT"
  head "https://github.com/SanderMertens/flecs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "322987e6f93be696986ec646a8ee045269e761ba024337ba0bbc19dde55f41e1"
    sha256 cellar: :any,                 arm64_sequoia: "2bfadf9de51d17b7415e8ee5f33f6a6219346783ce580829977b0cd5174cc65b"
    sha256 cellar: :any,                 arm64_sonoma:  "c9150de85591ea2b235a7ab7946f3e70699dab3c47c8b8cd33183f7605185b07"
    sha256 cellar: :any,                 sonoma:        "c3ba051542dd8e78b9baaba0fcf8bb00923c0fa48980e527990053775cca644c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94245debe43b8ebd697c465405ba1a3c98ad20c0cad0e97024af4cf1834c002c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1975d8f3cc46c3030bc9c0b9e754da541e66433c069f06bcceaedd47a6382129"
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
