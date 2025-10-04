class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.4/libass-0.17.4.tar.xz"
  sha256 "78f1179b838d025e9c26e8fef33f8092f65611444ffa1bfc0cfac6a33511a05a"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7b56025da7bfcff9b6d784a2a8179d05f820d9662b67366173c99b3336c3b32"
    sha256 cellar: :any,                 arm64_sequoia: "d097cb72eb4e70bce4ca584649fa8874e4407da3067d6faa0dcc89013ffe1743"
    sha256 cellar: :any,                 arm64_sonoma:  "e24acdc3f1045ed1185c18c3aa48b79bc974df9ec00ebebfa6df2efdd457d9a9"
    sha256 cellar: :any,                 arm64_ventura: "b7b2a447ccc5b838711fdae09c3f01c893ee2e0c81154dcc59efa929280c8550"
    sha256 cellar: :any,                 sonoma:        "92276181000efe0ae9530213fed782fa369d434085817225c731785c155b582d"
    sha256 cellar: :any,                 ventura:       "10c35278d132dadf11ff7afb87c0712163dec1bac261cd10906ebe54d9b04c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec085b343bf997b2b0fa3fbdd4fa560c54953f5b6b1cb93ff42ec2fbcb0ce9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7521ae0626fddeea2cb88b3d34c1243b9aa26ec7c76fb4e4a05b956f01a507e8"
  end

  head do
    url "https://github.com/libass/libass.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "libunibreak"

  on_linux do
    depends_on "fontconfig"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    # libass uses coretext on macOS, fontconfig on Linux
    args = OS.mac? ? ["--disable-fontconfig"] : []

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ass/ass.h"
      int main() {
        ASS_Library *library;
        ASS_Renderer *renderer;
        library = ass_library_init();
        if (library) {
          renderer = ass_renderer_init(library);
          if (renderer) {
            ass_renderer_done(renderer);
            ass_library_done(library);
            return 0;
          }
          else {
            ass_library_done(library);
            return 1;
          }
        }
        else {
          return 1;
        }
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    system "./test"
  end
end
