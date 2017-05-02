class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.2.tar.xz"
  sha256 "bea6fdec3d10939954495da898d872ee836b75c35699074cbf02a64fcb80d5b3"

  bottle do
    cellar :any
    sha256 "ebaebfb27513e366d1917e48a2fd1f2c68394a7213f35f4b4d88d96db8d6757f" => :sierra
    sha256 "54e86d039473c9971023253694b36d8a38824f4df97a8095de90bb4bf0557d8f" => :el_capitan
    sha256 "fcf8b7560ec836403bcae4d69a16c27793a7042b09673e1c2914cf010d6381f1" => :yosemite
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
