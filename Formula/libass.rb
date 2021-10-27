class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.15.2/libass-0.15.2.tar.xz"
  sha256 "1be2df9c4485a57d78bb18c0a8ed157bc87a5a8dd48c661961c625cb112832fd"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "960fdb749807d168b8cb1a5078d3ed6c94c12b1a8fea10b69c0fe81c79cad193"
    sha256 cellar: :any,                 arm64_big_sur:  "03a65a8977885e70b3072ed5b3cbb51178a140107932715f47fee5ee5b574d83"
    sha256 cellar: :any,                 monterey:       "e073fb7509cda2ce5054af65c5444f28e9166f40d3e41cc7cf6e92beace1c906"
    sha256 cellar: :any,                 big_sur:        "d11e2972aa5ae2e763cf4101712fac61421082db4d47720a8adc17b8a3e84a27"
    sha256 cellar: :any,                 catalina:       "b5f4cf1923f523dcc6faccd7d886c9677555c99d74f0bba2ea6f7aeaccd5511a"
    sha256 cellar: :any,                 mojave:         "046012d55a33f84e483ac1e080c5698e0b2040b6385b6806ca7867226b91654f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e453427bba31a08dfc4908ed2454c2478b687fca0c8be3cf573f01e0e73d0e"
  end

  head do
    url "https://github.com/libass/libass.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "autoreconf", "-i" if build.head?
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    # libass uses coretext on macOS, fontconfig on Linux
    args << "--disable-fontconfig" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    system "./test"
  end
end
