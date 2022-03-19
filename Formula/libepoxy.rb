class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.10.tar.xz"
  sha256 "072cda4b59dd098bba8c2363a6247299db1fa89411dc221c8b81b8ee8192e623"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe11d99878bb543ec53011dee5708ddba3a03002bc97e2b168287d0145eb29b6"
    sha256 cellar: :any,                 arm64_big_sur:  "bef593b27303538be08e325834c854e1b08b7e4ba63488c136626974ac8c7d7c"
    sha256 cellar: :any,                 monterey:       "0eaa2b1ab946f8dde3569df9a0938cb95352e13448b40d03eac3f91ccc435000"
    sha256 cellar: :any,                 big_sur:        "f36c2e70c1c4b91a9dbcd1e0cb06f413f93a2784bfab4b63a72e3f9a75849135"
    sha256 cellar: :any,                 catalina:       "56a143b316f80cb1f668cdd61691266ae31ed5b2e855dafabeacf6e8d5d423e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67bc0edb011e78d4b513ed0be3b583259697bd0d82b0dd8c504f580aacb0e31f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

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
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
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
