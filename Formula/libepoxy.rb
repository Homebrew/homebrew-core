class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.2.tar.xz"
  sha256 "bea6fdec3d10939954495da898d872ee836b75c35699074cbf02a64fcb80d5b3"

  bottle do
    cellar :any
    sha256 "e475eea8fa81f14b2984da71874ec3c00c8e9edcec84e9ae15eb0df5926afec7" => :sierra
    sha256 "1f064ae908ed05131d247a67361bfc7532378b29d973e464a832e89b81d7a415" => :el_capitan
    sha256 "427431ddadd2bc8da2e970be23ea8c04e46a1e117c6cde38b22a69ea428c9bb7" => :yosemite
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
