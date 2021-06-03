class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.8.tar.xz"
  sha256 "cf05e4901778c434aef68bb7dc01bea2bce15440c0cecb777fb446f04db6fe0d"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "af3bc3c7e7710cff30fdebbe386f52fab7cd5083b41d6d9a043eba4b2b1c049a"
    sha256 cellar: :any, big_sur:       "4a6a1766bb7ff4a4c9dbd5136f655685141a3c3eae8b082edc94cada21f613ec"
    sha256 cellar: :any, catalina:      "2af927d87affad9ff2ba2bce8b9410f1a7b131ddbd82ba157ffd0ec6a31b15b9"
    sha256 cellar: :any, mojave:        "9ff86759f0fce587b7063d2f2b156c3da556d54d6e40a108f72e1813580329bf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  on_linux do
    depends_on "freeglut"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    on_macos do
      args += %w[-framework OpenGL -DOS_MAC]
    end
    args += %w[-o test]
    system ENV.cc, "test.c", "-L#{lib}", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
