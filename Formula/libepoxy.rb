class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.3.tar.xz"
  sha256 "002958c5528321edd53440235d3c44e71b5b1e09b9177e8daf677450b6c4433d"

  bottle do
    cellar :any
    sha256 "2b40b669394b38062aeb683c72a53c73a6a48420d7529c5862290a4721850bb7" => :catalina
    sha256 "2effda8b89a49b5dbd3860061666757e58ba982534e42507e29ea3646f896178" => :mojave
    sha256 "0f7ebb1bf7449c25196dd2f3500e520a2b0eb67ac21263ec87c9d02c7d9e7e58" => :high_sierra
    sha256 "147538004325b02238d187ec1ef55944a0e74fe83accf1506904b62d01f75ec2" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  def install
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
