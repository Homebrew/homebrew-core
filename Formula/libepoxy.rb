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
    sha256 cellar: :any,                 arm64_monterey: "a5164efc11c9f11adaba87595c6a12cadf12671e860e9b38d11fa3081c7b2c1c"
    sha256 cellar: :any,                 arm64_big_sur:  "839cc3388516586debdc98d72a3fb4b8237ee432a5be7262e8c835367093f29d"
    sha256 cellar: :any,                 monterey:       "9ec0246218c3d31cfce70e1a492f7cdc03884f638d9986be28bec0b769d6648b"
    sha256 cellar: :any,                 big_sur:        "c398ece0b10339f409d48d3b06866285f7a58294a3dca6d9c88e798a35af6b36"
    sha256 cellar: :any,                 catalina:       "2b5537e288b18b6545d0cf78229d5c2b695d0d2e51b627e21e77573c88217b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8798e1682f355df0c5009b8b968ecb2b9bd447f32683ad21f10e68ea60320819"
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
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", "-L#{lib}", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
