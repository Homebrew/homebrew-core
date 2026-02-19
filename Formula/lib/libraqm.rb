class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "6b583fb0eb159a3727a1e8c653bb0294173a14af8eb60195a775879de72320a3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80573133b47b2923ed7e407a873c31f71c88acd9c84553a289757a908bcaf386"
    sha256 cellar: :any, arm64_sequoia: "d6d61caf0cfea3c41e461f5a1025cccb581df32833095c54deb9ac1a9c7a1782"
    sha256 cellar: :any, arm64_sonoma:  "7123cff4762e4ec7d1045f20789fc1eecc2529a69c84e0c3f8a89c1cd91acc18"
    sha256 cellar: :any, sonoma:        "85ebe16cdd41a156dac23c0d97faf8efb6456ca34cb016ba1c94110f21c1e317"
    sha256               arm64_linux:   "b39145fa67adc360e8bbb66372ca603600a7c4a206d528f552554742f74d0a8f"
    sha256               x86_64_linux:  "5163492384bc5eb6606b7d7cc490962fe0da9cfcf24f0557408d5bdfe4f84675"
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
