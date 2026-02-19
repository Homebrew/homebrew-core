class Flecs < Formula
  desc "Fast entity component system for C & C++"
  homepage "https://www.flecs.dev"
  url "https://github.com/SanderMertens/flecs/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "1ecd4b2b463388d1243c15a900dd62096b28cebba48ad76c204b562304945f0d"
  license "MIT"
  head "https://github.com/SanderMertens/flecs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1948ed7316bb35b72c97963a91e5b63283b3ab29d15d6142eec5a58aaa584b64"
    sha256 cellar: :any,                 arm64_sequoia: "23ffa4826670bbc60027eb73317ab5cbc9d67d63a35da3b6feee0f05fb1b80bd"
    sha256 cellar: :any,                 arm64_sonoma:  "70a192afc7f284346d313a2bc4d345fa6cb3e3fc1ccf0a796cbe854623b729e2"
    sha256 cellar: :any,                 sonoma:        "6575962e5371627197bccaeea24a6ee2ee43222068dac476b1bf2d69e354a187"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a05018d389b69b91b4d5cdc506e99a77ada22faa368c987ce4038eadccc4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61397dd0b15abb4d5656cc819bf676d39e8d2043156baca646ffb5e8e11b8599"
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
