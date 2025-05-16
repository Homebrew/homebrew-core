class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://github.com/darkbitsorg/guichan"
  url "https://github.com/darkbitsorg/guichan/releases/download/v0.8.3/guichan-0.8.3.tar.gz"
  sha256 "2f3b265d1b243e30af9d87e918c71da6c67947978dcaa82a93cb838dbf93529b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9946ca2ce53833770ba41ce2f9fc5b630e46d595b1aaf893e8be3a302841dda"
    sha256 cellar: :any,                 arm64_ventura:  "ff8971a12e820a77df5f570dbe145fb5f1046d851d713d8f26f89030429ea93a"
    sha256 cellar: :any,                 arm64_monterey: "917384f24bef699687d0cdd48867f03733db6aeee593537da519360e250fd22e"
    sha256 cellar: :any,                 arm64_big_sur:  "3acc3607e1930e9864934244b269370ffc35081c10138daf9b61254195bacc7f"
    sha256 cellar: :any,                 sonoma:         "e5a2bcb4611579d22df6474a8986d6127478a4ab9b14dc4bca10cbeb490bd9b1"
    sha256 cellar: :any,                 ventura:        "5415af4555a0b2bbacc69dfba87485659a55dc3d7a80c24599a172036235da5d"
    sha256 cellar: :any,                 monterey:       "1ef2ef362f796f72ba510c5e1878e8b290846bec405e7b5240e8485971ae6950"
    sha256 cellar: :any,                 big_sur:        "2d4f9b296640bffe66b4eb09642ab499517d050821de8299da838937f8611542"
    sha256 cellar: :any,                 catalina:       "93a5e8526479a48a82a7890393b2e8871e3cb2e4dae4fae4bddb964177fe784e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654afd1dcf4f1fa523bba39ded7799d50ec10918eeece0aa5274ba123de17cea"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"helloworld.cpp").write <<~EOS
      #include <iostream>
      #include <guichan.hpp>

      class MyInput : public gcn::Input
      {
      public:
          MyInput() {}

          bool isKeyQueueEmpty() { return true; }
          gcn::KeyInput dequeueKeyInput() { return gcn::KeyInput(); }

          bool isMouseQueueEmpty() { return true; }
          gcn::MouseInput dequeueMouseInput() { return gcn::MouseInput(); }

          void _pollInput() {}
      };

      class MyImage : public gcn::Image
      {
      public:
          MyImage(const std::string& path) : mPath(path) {}

          void free() {};
          int getWidth() const { return 0; };
          int getHeight() const { return 0; };
          gcn::Color getPixel(int x, int y) { return gcn::Color(0, 0, 0); };
          void putPixel(int x, int y, const gcn::Color& color) {};
          void convertToDisplayFormat() {};

          const std::string& getPath() const { return mPath; }

      private:
          const std::string mPath;
      };

      class MyGraphics : public gcn::Graphics
      {
      public:
          MyGraphics() {}

          void drawImage(const gcn::Image* image,
                        int srcX,
                        int srcY,
                        int dstX,
                        int dstY,
                        int width,
                        int height)
          {
              if (const MyImage* myImage = dynamic_cast<const MyImage*>(image))
              {
                  const gcn::ClipRectangle &clipArea = getCurrentClipArea();
                  std::cout << "Rendering image " << myImage->getPath() << " at ("
                            << clipArea.xOffset + dstX << ", " << clipArea.yOffset + dstY << ")"
                            << std::endl;
              }
          }

          void drawPoint(int x, int y) {};
          void drawLine(int x1, int y1, int x2, int y2) {};
          void drawRectangle(const gcn::Rectangle& rectangle) {};
          void fillRectangle(const gcn::Rectangle& rectangle) {};
          void setColor(const gcn::Color& color) { mColor = color; };
          const gcn::Color& getColor() const { return mColor; };

      private:
          gcn::Color mColor;
      };

      class MyImageLoader : public gcn::ImageLoader
      {
      public:
          MyImageLoader() {}

          gcn::Image* load(const std::string& filename, bool convertToDisplayFormat = true)
          {
              gcn::Image* image = new MyImage(filename);
              if (convertToDisplayFormat)
                  image->convertToDisplayFormat();
              return image;
          }
      };

      class MyFont : public gcn::Font
      {
      public:
          int getWidth(const std::string &text) const { return 0; }
          int getHeight() const { return 0; }

          void drawString(gcn::Graphics *graphics, const std::string &text, int x, int y)
          {
              const gcn::ClipRectangle &clipArea = graphics->getCurrentClipArea();
              std::cout << "Drawing string: " << text << " at (" << clipArea.xOffset + x << ", "
                        << clipArea.yOffset + y << ")" << std::endl;
          }
      };

      int main(int argc, char **argv)
      {
          MyInput myInput;
          MyGraphics myGraphics;
          MyImageLoader myImageLoader;
          MyFont myFont;

          gcn::Image::setImageLoader(&myImageLoader);
          gcn::Widget::setGlobalFont(&myFont);

          gcn::Gui gui;
          gui.setInput(&myInput);
          gui.setGraphics(&myGraphics);

          gcn::Icon icon("icon.png");
          gcn::Label label("Hello, Guichan!");
          gcn::Container container;
          container.setDimension(gcn::Rectangle(0, 0, 200, 200));
          container.add(&label, 10, 10);
          container.add(&icon, 10, 30);
          gui.setTop(&container);

          gui.logic();
          gui.draw();

          return 0;
      }
    EOS

    flags = [
      "-L#{lib}", "-lguichan"
    ]

    flags << (OS.mac? ? "-lc++" : "-lstdc++")

    system ENV.cc, "helloworld.cpp", ENV.cppflags,
                   *flags, "-o", "helloworld"
    system "./helloworld"
  end
end
