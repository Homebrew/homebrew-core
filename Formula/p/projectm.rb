class Projectm < Formula
  desc "Milkdrop-compatible music visualizer"
  homepage "https://github.com/projectM-visualizer/projectm"
  url "https://github.com/projectM-visualizer/projectm/releases/download/v4.1.3/libprojectM-4.1.3.tar.gz"
  sha256 "fedb7064306da219ab0dfac2f1080f1cf594b720fa039dfad29b2c55381db614"
  license "LGPL-2.1-or-later"
  head "https://github.com/projectM-visualizer/projectm.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "a579de759ddbc2ca8b39a3dfc1cd7d2b936369790efaeda1c59efdbd63db5b2f"
    sha256 arm64_sonoma:   "a854f24612ce8bd9456d71f42d0e02bdca89fe39e4d8a4009f56f06536255f72"
    sha256 arm64_ventura:  "f3f6b5e3b0d40bcc55658e7f06f16ae49eb4cdc449772b5dc526a84e40c965e0"
    sha256 arm64_monterey: "a8dae00eb95d2123fda97a19085933944cc35cc1bb2eceaad0b2bb8555e4f961"
    sha256 arm64_big_sur:  "4124ed10310e00ab4d706dcf40814adf0497af26cc95733aec708b82f4aaeced"
    sha256 sonoma:         "22a8e128f8a99fa09e7b99ad12cdb6da037e9417beb4f6ae4a712ed096d7f214"
    sha256 ventura:        "68f9b93a6f6abef42c42bbcc8a70be06fb9845bf1caa5b68cd7e14beba13ca5f"
    sha256 monterey:       "473cd386b1daec76f796cffff2c29b6b6cc57f749a517f91cc5466a7ccc2fd81"
    sha256 big_sur:        "c8ece4df06966643cf9aaae5f31610b98eaacddbfb7b0e56b21531d5e2f8f1a5"
    sha256 catalina:       "8d11933c220cde67c4515ee5d42d99bc8e1c18479a4d3b746074c6080712cf0f"
    sha256 mojave:         "9f7aef06ab68d557c1c989e08709903511a4fcd74fd166559d4f7bbf6af55548"
    sha256 x86_64_linux:   "05caf42b3d5a023b4c22e2f51e7699645cc5077fbd37c7c27f1f8260025d608b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
  end

  resource "projectM-eval" do
    url "https://github.com/projectM-visualizer/projectm-eval/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "64656e8fc58ba414036284094767812d8da60c3d429671b0c35eccc1658ab9d0"
  end

  def install
    resource("projectM-eval").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_predicate lib/"libprojectM-4.so", :exist? if OS.linux?
    assert_predicate lib/"libprojectM-4.dylib", :exist? if OS.mac?

    (testpath/"test.c").write <<~C
      #include <SDL2/SDL.h>

      #include <projectM-4/projectM.h>

      #include <stdlib.h>
      #include <stdio.h>

      int main(void)
      {
          if (SDL_Init(SDL_INIT_VIDEO) < 0)
          {
              fprintf(stderr, "Video init failed: %s", SDL_GetError());
              return 1;
          }

          SDL_Window* win = SDL_CreateWindow("projectM Test", 0, 0, 320, 240,
              SDL_WINDOW_OPENGL | SDL_WINDOW_ALLOW_HIGHDPI);
          if (win == NULL)
          {
              fprintf(stderr, "SDL Window creation failed: %s", SDL_GetError());
              return 2;
          }

          SDL_GLContext glCtx = SDL_GL_CreateContext(win);
          if (glCtx == NULL)
          {
              fprintf(stderr, "SDL GL context creation failed: %s", SDL_GetError());
              return 3;
          }

          projectm_handle pm = projectm_create();
          if (pm == NULL)
          {
              fprintf(stderr, "projectM instance creation failed: %s", SDL_GetError());
              return 4;
          }

          // Clean up.
          projectm_destroy(pm);
          SDL_Quit();

          return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs projectM-4 sdl2").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags

    # Fails in Linux CI with "Video init failed: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
