class Projectm < Formula
  desc "Milkdrop-compatible music visualizer"
  homepage "https://github.com/projectM-visualizer/projectm"
  url "https://github.com/projectM-visualizer/projectm/releases/download/v3.1.12/projectM-3.1.12.tar.gz"
  sha256 "b6b99dde5c8f0822ae362606a0429628ee478f4ec943a156723841b742954707"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7f0815b03bcecd38afe7c9a8750a0822d9a17646c7e92f420e0fedb096c2709c"
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
    sha256 arm64_linux:    "c3813a64b58332351ad6fe801cd1ede4ac96bdc17d6eaae7937571e149f6a253"
    sha256 x86_64_linux:   "05caf42b3d5a023b4c22e2f51e7699645cc5077fbd37c7c27f1f8260025d608b"
  end

  head do
    url "https://github.com/projectM-visualizer/projectm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_path_exists prefix/"share/projectM/config.inp"
    assert_path_exists prefix/"share/projectM/presets"

    (testpath/"test.cpp").write <<~CPP
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
    CPP
    flags = shell_output("pkgconf libprojectM sdl2 --cflags --libs").split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags

    # Fails in Linux CI with "Video init failed: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
