class Guichan < Formula
  desc "small, efficient C++ GUI library designed for games"
  homepage "http://guichan.sourceforge.net/oldsite/about.shtml"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/guichan/guichan-0.8.2.tar.gz"
  sha256 "eedf206eae5201eaae027b133226d0793ab9a287bfd74c5f82c7681e3684eeab"

  bottle do
    cellar :any
    sha256 "980c483e7566fc69294a26a603bcf474fe74c660840916ef238ea9f88a27daed" => :el_capitan
    sha256 "60ac3594c93c20b0a992d85990d981e9d5f9de42492c0f3ab7b49a83286e655f" => :yosemite
    sha256 "8e1358e9b004b2889abb90ff24fb9ce22f2fa6efb856db76a708ececac0609f1" => :mavericks
  end

  depends_on "sdl_image"
  # "with-allegro" requires allegero-config. But that is no longer supplied from ver. 4.9.

  resource "fixedfont.bmp" do
    url "http://guichan.sourceforge.net/oldsite/images/fixedfont.bmp"
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
    (testpath/"helloworld.cpp").write <<-EOS.undent
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
    system ENV.cc, "helloworld.cpp", ENV.cppflags, "-I#{HOMEBREW_PREFIX}/include/SDL",
        "-L#{Formula["SDL"].opt_lib}", "-framework", "Foundation", "-framework", "CoreGraphics", "-framework", "Cocoa",
        "-lSDL", "-lSDLmain", "-lSDL_image", "-lguichan", "-lguichan_sdl", "-lobjc", "-lc++", "-o", "helloworld"
    helloworld = fork do
      system testpath/"helloworld"
    end
    Process.kill("TERM", helloworld)
  end
end
