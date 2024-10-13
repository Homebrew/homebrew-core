class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.3/libass-0.17.3.tar.xz"
  sha256 "eae425da50f0015c21f7b3a9c7262a910f0218af469e22e2931462fed3c50959"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2c948ddd9b7a94dd267cdc24cd684903b292d26d6ce92e6d2d7c68136b071e4d"
    sha256 cellar: :any,                 arm64_sonoma:   "9e8889c7d434e4a56a0f9abbb1fded340dae984d05121ad5413715e3abb03fd3"
    sha256 cellar: :any,                 arm64_ventura:  "d0724c2ba6a6aa6f1ffb604a5cde5bf341e835369e72216042bbb2587acb83cf"
    sha256 cellar: :any,                 arm64_monterey: "f16d796553df4b3ae94c458ae687ce824ea8e66a75bd66ff6df2f0bfe4202ab7"
    sha256 cellar: :any,                 sonoma:         "4db6c9473a71166cd6cc5d95b5fab7da9432e081855aad495fe2eb7c0b51bf31"
    sha256 cellar: :any,                 ventura:        "1284a21e45e033cf6df87e7fc01e3d9fb3204e24ba5580bdfac941fff69e9a63"
    sha256 cellar: :any,                 monterey:       "07a27068fd1c52b021d39b0cd9daa99b2fd6f0ac8f70e05b20b9116c5d848507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ef7e90470c2f9a0304b343b6216b9632be26599ca0cbadd3705d5cbf11851b"
  end

  head do
    url "https://github.com/libass/libass.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
