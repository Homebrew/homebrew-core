class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2ba3521d3f24e9696185a67a16f1a9643429d6c897d89d83dfb2aad3a398732a"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc58087be4b56fc11117a57536b22de178c9349003baa4d2d46b1f650468bbbe"
    sha256 cellar: :any, arm64_sequoia: "562eae89ec18a9e0fe45e3c3337e029802fe59263acf4fb4da8509c8a6986a43"
    sha256 cellar: :any, arm64_sonoma:  "4b8a1afeeb2e0a26d645fa7af7f141df7b72f62ce0be71b68d0b7b81e36b8fb6"
    sha256 cellar: :any, sonoma:        "d97d2ceadd75f4d04d4dcec710e804acf7c7843e975f2a89d19314807101c172"
    sha256               arm64_linux:   "06e46b668a296337559f390e852f76677dc4b31c9ac691d95fab45d19f4c623c"
    sha256               x86_64_linux:  "fd5e6f285625d73d32d5869a0d364479c2251a7a7e53ecdbc477444631cf8603"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <raqm.h>

      int main() {
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end
