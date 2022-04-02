class Projectm < Formula
  desc "Milkdrop-compatible music visualizer"
  homepage "https://github.com/projectM-visualizer/projectm"
  url "https://github.com/projectM-visualizer/projectm/releases/download/v3.1.12/projectM-3.1.12.tar.gz"
  sha256 "b6b99dde5c8f0822ae362606a0429628ee478f4ec943a156723841b742954707"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "a8dae00eb95d2123fda97a19085933944cc35cc1bb2eceaad0b2bb8555e4f961"
    sha256 arm64_big_sur:  "4124ed10310e00ab4d706dcf40814adf0497af26cc95733aec708b82f4aaeced"
    sha256 monterey:       "473cd386b1daec76f796cffff2c29b6b6cc57f749a517f91cc5466a7ccc2fd81"
    sha256 big_sur:        "c8ece4df06966643cf9aaae5f31610b98eaacddbfb7b0e56b21531d5e2f8f1a5"
    sha256 catalina:       "8d11933c220cde67c4515ee5d42d99bc8e1c18479a4d3b746074c6080712cf0f"
    sha256 mojave:         "9f7aef06ab68d557c1c989e08709903511a4fcd74fd166559d4f7bbf6af55548"
  end

  head do
    url "https://github.com/projectM-visualizer/projectm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_predicate prefix/"share/projectM/config.inp", :exist?
    assert_predicate prefix/"share/projectM/presets", :exist?

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
    flags = shell_output("pkg-config libprojectM sdl2 --cflags --libs").split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags

    # Fails in Linux CI with "Video init failed: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
