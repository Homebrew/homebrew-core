class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.0.tar.xz"
  sha256 "25a906b14a921bc2b488cfeaa21a00486fe92630e4a9dd346e4ecabeae52ab41"

  bottle do
    cellar :any
    sha256 "1b3a83b5741d9e442e79f5b9a6ed93db92733c3d85409700f1424bc7f2cec99d" => :sierra
    sha256 "3551c12b29c78c909f6b4cd9b09cc75dded48332be5122679a3662963d8721c0" => :el_capitan
    sha256 "4c4c34f77832f75974a9ce48020391a03830b5649a6759253ce208a6eca63074" => :yosemite
    sha256 "edc04249dcc083ed487de29eb8401d788fbcfed58988ebe6a75e1cae5613831f" => :mavericks
    sha256 "495b9da3d417b836eaf1cdd1aba41782d975d0b3d007e1f9c91fab7e57c2a197" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    ENV.universal_binary if build.universal?

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
