class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.3.tar.xz"
  sha256 "002958c5528321edd53440235d3c44e71b5b1e09b9177e8daf677450b6c4433d"

  bottle do
    cellar :any
    sha256 "20c457ac30badc18f3b02c37ba8dfe865773fd5c50aa0ce3ac550581014bceae" => :mojave
    sha256 "0748efd9737fe67c0b55dc6b21b927e20b3e816eb44813b99d76b2c1dd301008" => :high_sierra
    sha256 "815b406da30c03dc46621d217e5fd0e2b7de30194f455943e214afa397dc68bc" => :sierra
    sha256 "a1d5c559a7a5c84316b2adb75fab79297b27ecb301bf60ef6cd69baf8a367158" => :el_capitan
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
