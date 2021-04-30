class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.6.tar.xz"
  sha256 "5b38c330f22430e516bd925aa0248d247486c17092bb3c8570f8211955e6258c"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f4b0803937d1fa962e698890caa1ec96d7ba1847a4df990ad07db5ed480d8821"
    sha256 cellar: :any, big_sur:       "70c98f994735bd0cd3c23286460c06fcbe324294f97b61ea91dc72303132c64d"
    sha256 cellar: :any, catalina:      "f410ca0d9f4d101901beec178b22f4e65facdad58d496c7b2b5f9a56ec241852"
    sha256 cellar: :any, mojave:        "4ca20871fe9fd9bf37cebd4dc3b7f081406dc08d60c404d970132cb48f26900b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

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
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
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
