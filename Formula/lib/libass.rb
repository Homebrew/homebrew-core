class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.5/libass-0.17.5.tar.xz"
  sha256 "2dca25c0e0c837ddf00b52011b3f82cac1e4ddd3ad018227806b0c2288864acc"
  license "ISC"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47e1f2d60c97628331593c00673e03d00e675c2462c1267f1e459ba17a41129e"
    sha256 cellar: :any, arm64_sequoia: "3600420037feb1403141c0f6d07f135dcd79649cafa420ace2750468981664ec"
    sha256 cellar: :any, arm64_sonoma:  "a14b9e2407d406f58b7a83c7c22d9332b69ba68dca53dd7e61d7e0afa0468ed4"
    sha256 cellar: :any, sonoma:        "e380b555c2987bac9cfe30d47e2aaadd07112073cc263dee9d992f488297fe74"
    sha256 cellar: :any, arm64_linux:   "5b13b14c5716ad5b9a1082e9d05f3f7cbb4aaf616bb19c03483e3f981b9b075f"
    sha256 cellar: :any, x86_64_linux:  "c6a9a61e5e5b9f6a445a63690603bec9bc8c56513a2b69dd8ca3eab530b98ccc"
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
