class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.1.tar.xz"
  sha256 "88c6abf5522fc29bab7d6c555fd51a855cbd9253c4315f8ea44e832baef21aa6"

  bottle do
    cellar :any
    sha256 "a3cab4d43a9fa2fd109c8e47d90985770fbcc09cbebe1913cd4bf3fdc89c6fa8" => :sierra
    sha256 "2435fa039229e575b6491299548b0cc4507cfac13e62c0b5213f862902514fb2" => :el_capitan
    sha256 "f95aff4f5d3aed6991335ea6f67e3377a8a99200a554ca2cb0026c5e20630523" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent

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
    system ENV.cc, "test.c", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
