class Projectm < Formula
  desc "Milkdrop-compatible music visualizer"
  homepage "https://github.com/projectM-visualizer/projectm"
  url "https://github.com/projectM-visualizer/projectm/releases/download/v3.1.12/projectM-3.1.12.tar.gz"
  sha256 "b6b99dde5c8f0822ae362606a0429628ee478f4ec943a156723841b742954707"
  license "LGPL-2.1-or-later"
  head do
    url "https://github.com/projectM-visualizer/projectm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config"
  depends_on "sdl2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprojectM/projectM.hpp>
      #include <SDL2/SDL.h>
      #include <stdlib.h>
      #include <stdio.h>

      int main()
      {
        // initialize SDL video + openGL
        if (SDL_Init(SDL_INIT_VIDEO) < 0)
        {
          fprintf(stderr, "Video init failed: %s", SDL_GetError());
          return 1;
        }
        atexit(SDL_Quit);

        SDL_Window *win = SDL_CreateWindow("projectM Test", 0, 0, 320, 240,
                                          SDL_WINDOW_OPENGL | SDL_WINDOW_ALLOW_HIGHDPI);
        SDL_GLContext glCtx = SDL_GL_CreateContext(win);

        auto *settings = new projectM::Settings();
        auto *pm = new projectM(*settings, projectM::FLAG_DISABLE_PLAYLIST_LOAD);

        // if we get this far without crashing we're in good shape
        return 0;
      }
    EOS
    args = %w[test.cpp -o test]
    args += shell_output("pkg-config libprojectM sdl2 --cflags --libs").split
    system ENV.cxx, *args
    system "./test"

    assert_predicate prefix/"share/projectM/config.inp", :exist?
    assert_predicate prefix/"share/projectM/presets", :exist?
  end
end
