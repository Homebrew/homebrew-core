class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://guichan.sourceforge.io/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/guichan/guichan-0.8.2.tar.gz"
  sha256 "eedf206eae5201eaae027b133226d0793ab9a287bfd74c5f82c7681e3684eeab"

  bottle do
    cellar :any
    rebuild 1
    sha256 "20887eab0782fcd2eb3e922b1f388831057b0faaeab519e98590118853c48e3c" => :mojave
    sha256 "c685850224a216a61b5d0fb96aeb56935deb2187f2781bac7e64668e93baf3ab" => :high_sierra
    sha256 "d98d6bdc213bca6d4d6fbf904e91f45dd678996ae5522b194805e3bd098c87fb" => :sierra
  end

  depends_on "sdl_image"

  resource "fixedfont.bmp" do
    url "https://guichan.sourceforge.io/oldsite/images/fixedfont.bmp"
    sha256 "fc6144c8fefa27c207560820450abb41378c705a0655f536ce33e44a5332c5cc"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["sdl_image"].opt_include}/SDL"
    ENV.append "LDFLAGS", "-lSDL -lSDL_image -framework OpenGL"
    inreplace "src/opengl/Makefile.in", "-no-undefined", " "
    inreplace "src/sdl/Makefile.in", "-no-undefined", " "

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("fixedfont.bmp")
    (testpath/"helloworld.cpp").write <<~EOS
      #include <iostream>
      #include <guichan.hpp>
      #include <guichan/sdl.hpp>
      #include "SDL/SDL.h"

      bool running = true;

      SDL_Surface* screen;
      SDL_Event event;

      gcn::SDLInput* input;             // Input driver
      gcn::SDLGraphics* graphics;       // Graphics driver
      gcn::SDLImageLoader* imageLoader; // For loading images

      gcn::Gui* gui;            // A Gui object - binds it all together
      gcn::Container* top;      // A top container
      gcn::ImageFont* font;     // A font
      gcn::Label* label;        // And a label for the Hello World text

      void init()
      {
          SDL_Init(SDL_INIT_VIDEO);
          screen = SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE);
          SDL_EnableUNICODE(1);
          SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);

          imageLoader = new gcn::SDLImageLoader();
          gcn::Image::setImageLoader(imageLoader);
          graphics = new gcn::SDLGraphics();
          graphics->setTarget(screen);
          input = new gcn::SDLInput();

          top = new gcn::Container();
          top->setDimension(gcn::Rectangle(0, 0, 640, 480));
          gui = new gcn::Gui();
          gui->setGraphics(graphics);
          gui->setInput(input);
          gui->setTop(top);
          font = new gcn::ImageFont("fixedfont.bmp", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
          gcn::Widget::setGlobalFont(font);

          label = new gcn::Label("Hello World");
          label->setPosition(280, 220);
          top->add(label);
      }

      void halt()
      {
          delete label;
          delete font;
          delete top;
          delete gui;
          delete input;
          delete graphics;
          delete imageLoader;
      }

      void checkInput()
      {
          while(SDL_PollEvent(&event))
          {
              if (event.type == SDL_KEYDOWN)
              {
                  if (event.key.keysym.sym == SDLK_ESCAPE)
                  {
                      running = false;
                  }
                  if (event.key.keysym.sym == SDLK_f)
                  {
                      if (event.key.keysym.mod & KMOD_CTRL)
                      {
                          // Works with X11 only
                          SDL_WM_ToggleFullScreen(screen);
                      }
                  }
              }
              else if(event.type == SDL_QUIT)
              {
                  running = false;
              }
              input->pushInput(event);
          }
      }

      void run()
      {
          while(running)
          {
              checkInput();
              gui->logic();
              gui->draw();
              SDL_Flip(screen);
          }
      }

      int main(int argc, char **argv)
      {
          try
          {
               init();
              run();
              halt();
          }
          catch (gcn::Exception e)
          {
              std::cerr << e.getMessage() << std::endl;
              return 1;
          }
          catch (std::exception e)
          {
              std::cerr << "Std exception: " << e.what() << std::endl;
              return 1;
          }
          catch (...)
          {
              std::cerr << "Unknown exception" << std::endl;
              return 1;
          }
          return 0;
      }
    EOS
    system ENV.cc, "helloworld.cpp", ENV.cppflags,
                   "-I#{HOMEBREW_PREFIX}/include/SDL",
                   "-L#{Formula["sdl"].opt_lib}",
                   "-L#{Formula["sdl_image"].opt_lib}",
                   "-framework", "Foundation",
                   "-framework", "CoreGraphics",
                   "-framework", "Cocoa",
                   "-lSDL", "-lSDLmain", "-lSDL_image",
                   "-L#{lib}", "-lguichan", "-lguichan_sdl",
                   "-lobjc", "-lc++", "-o", "helloworld"
    helloworld = fork do
      system testpath/"helloworld"
    end
    Process.kill("TERM", helloworld)
  end
end
