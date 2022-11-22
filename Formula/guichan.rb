class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://guichan.sourceforge.io/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/guichan/guichan-0.8.2.tar.gz"
  sha256 "eedf206eae5201eaae027b133226d0793ab9a287bfd74c5f82c7681e3684eeab"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff8971a12e820a77df5f570dbe145fb5f1046d851d713d8f26f89030429ea93a"
    sha256 cellar: :any,                 arm64_monterey: "917384f24bef699687d0cdd48867f03733db6aeee593537da519360e250fd22e"
    sha256 cellar: :any,                 arm64_big_sur:  "3acc3607e1930e9864934244b269370ffc35081c10138daf9b61254195bacc7f"
    sha256 cellar: :any,                 ventura:        "5415af4555a0b2bbacc69dfba87485659a55dc3d7a80c24599a172036235da5d"
    sha256 cellar: :any,                 monterey:       "1ef2ef362f796f72ba510c5e1878e8b290846bec405e7b5240e8485971ae6950"
    sha256 cellar: :any,                 big_sur:        "2d4f9b296640bffe66b4eb09642ab499517d050821de8299da838937f8611542"
    sha256 cellar: :any,                 catalina:       "93a5e8526479a48a82a7890393b2e8871e3cb2e4dae4fae4bddb964177fe784e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654afd1dcf4f1fa523bba39ded7799d50ec10918eeece0aa5274ba123de17cea"
  end

  depends_on "sdl_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  resource "fixedfont.bmp" do
    url "http://guichan.sourceforge.io/oldsite/images/fixedfont.bmp"
    sha256 "fc6144c8fefa27c207560820450abb41378c705a0655f536ce33e44a5332c5cc"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    gl_lib = OS.mac? ? "-framework OpenGL" : "-lGL"
    ENV.append "CPPFLAGS", "-I#{Formula["sdl_image"].opt_include}/SDL"
    ENV.append "LDFLAGS", "-lSDL -lSDL_image #{gl_lib}"
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

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/SDL",
      "-L#{Formula["sdl12-compat"].opt_lib}",
      "-L#{Formula["sdl_image"].opt_lib}",
      "-lSDL", "-lSDLmain", "-lSDL_image",
      "-L#{lib}", "-lguichan", "-lguichan_sdl"
    ]

    if OS.mac?
      flags += [
        "-framework", "Foundation",
        "-framework", "CoreGraphics",
        "-framework", "Cocoa",
        "-lobjc", "-lc++"
      ]
    else
      flags << "-lstdc++"
    end

    system ENV.cc, "helloworld.cpp", ENV.cppflags,
                   *flags, "-o", "helloworld"
    helloworld = fork do
      system testpath/"helloworld"
    end
    Process.kill("TERM", helloworld)
  end
end
