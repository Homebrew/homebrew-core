class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.7.tar.gz"
  sha256 "90b331c2fd2d0420767c4652e007d054c97a3f03a88c55e3b986bd3acfd7e338"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6923bb0f5f8d3af8c1165951de8d6132aa1de17c9882fc0fc2ed051f7b63ca7a"
    sha256 cellar: :any,                 arm64_sequoia: "ad1d313f2572ce8515429bc8dd9dab2ac9a4cc7e0b9f0510c7d4647968fc2b49"
    sha256 cellar: :any,                 arm64_sonoma:  "ffd1d65361a267305f7c2b0fc21f4e53cc0b1dd7cf6f5553d2ea9c9c52533436"
    sha256 cellar: :any,                 sonoma:        "41518f66f53d9ac2efc2c7fde9e919b9ed92b1eb91b0c4631fbec59022a966d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fce39009ed7ef80c230e3663b17fb82b70faeb4796e8a058cc3a0cfdebae5ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b750be1b1a0603cff595ed46908b6ce9cf7daa3ce8170ba8da567551b554a2"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => [:build, :test]
  depends_on "xtrans" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    configure_args = %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{Formula["xorgproto"].include}",
      "-L#{lib}", "-lXfont2"
    system "./test"
  end
end
