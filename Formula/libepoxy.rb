class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.2.tar.xz"
  sha256 "a9562386519eb3fd7f03209f279f697a8cba520d3c155d6e253c3e138beca7d8"

  bottle do
    cellar :any
    sha256 "068e7418ed83a620e757f4210e4813becf5cc3d6290a7e9b182c375561d0e928" => :high_sierra
    sha256 "daf5823671b71966017dfc59506b850824be070ecb13ee600b8b391e98a66b12" => :sierra
    sha256 "fd2bff08ce59cbf35dd0ba15e7b0d2bb53babd788ce5240dcfd948f0e68ef2e2" => :el_capitan
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  def install
    # Fix "Couldn't open libOpenGL.so.0: dlopen(libOpenGL.so.0, 5): image not found"
    # Reported 29 May 2018 https://github.com/anholt/libepoxy/issues/176
    inreplace "src/dispatch_common.c", '#define OPENGL_LIB "libOpenGL.so.0"', ""

    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
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
    system ENV.cc, "test.c", "-L#{lib}", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
