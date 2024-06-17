class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.2/libass-0.17.2.tar.xz"
  sha256 "e8261b51d66ba933fe99248c6fdd8767ed96c5a7e5363c83992c735a2c2fbf74"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87d9fe5a36cb16d1c89d489d4fad8609bd24989348a32c45211bc36b10a4e84b"
    sha256 cellar: :any,                 arm64_ventura:  "b7fee0f2e5c6d0d18bdfb64a96143426157bbd573606ae8798ed52d2f6522d86"
    sha256 cellar: :any,                 arm64_monterey: "e788f122320366f3ada5510fa365938078d93b3e9297703dac95072c78677a66"
    sha256 cellar: :any,                 sonoma:         "5b9b9dc3754f07eff37a4a09d9139e1671ab7107f586b861330d6aa47919e87f"
    sha256 cellar: :any,                 ventura:        "1b7357e49d57ee9b33ffdb04a10bc8ae4a2ab63e6f86c634033cee2d278f4596"
    sha256 cellar: :any,                 monterey:       "051ae8aed804db9f19c9bcbf392ee783e6502a3b7ec0b0c2f16135446959cf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fcfe468177e61784cce81e722bdcd6e16ff3a83dbc1b016ac5612a485c8c24"
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
