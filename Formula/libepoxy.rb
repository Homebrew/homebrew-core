class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.9.tar.xz"
  sha256 "d168a19a6edfdd9977fef1308ccf516079856a4275cf876de688fb7927e365e4"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5913aa7d3fd692d2ce8122074b4bbb50798073c0b7e0050d526a75a7809c276b"
    sha256 cellar: :any,                 arm64_big_sur:  "44bf396b28c0e629eac032d7fd6324bbda21d2cb949e9567999699bd65dd04c9"
    sha256 cellar: :any,                 monterey:       "c7186196ccbaa213eabd905e6b841daed9c5015a24a5e81d467c4f95c0ba9d7c"
    sha256 cellar: :any,                 big_sur:        "30b697cb414754b530f98c5112c5fd7755812448fda09dc19a3f157be116f39d"
    sha256 cellar: :any,                 catalina:       "db234371ccc41d4822ea369120cbbadc9f13c51c09b7340359ad2b1b6e252889"
    sha256 cellar: :any,                 mojave:         "40e2e8ead638260029388301a600403f17f5ea39a074159f14e08cfe21f868a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b6773ae50c02d16cde9b202a46a5ed7dbbaab4f22f4b3d57fb96572fe55ce8"
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
