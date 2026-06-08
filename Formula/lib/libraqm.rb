class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "7f3dd21b4b3bd28a36f2c911d31d91a9d69341697713923ef1aac65d56ebcafd"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b1117c8508549d57157890bf3acfacbc2d45de6197d188bf83474f30fd0f572"
    sha256 cellar: :any, arm64_sequoia: "4259ac8ccfb1e30bf67bac2188e12479af6e884a863d33b4c631edb42fa58aa0"
    sha256 cellar: :any, arm64_sonoma:  "0450f2947a22391458c06eb305ba09679689ad83642f0e9de65dfd99a7d2e414"
    sha256 cellar: :any, sonoma:        "f2a956bafe35455da4e6fa01f5ca1f65f32357935c731e5ac46ab4b7ff728290"
    sha256               arm64_linux:   "05ca1326319450ae29ab912a8bb707eb68361212a9f990ed74216007caef6a6c"
    sha256               x86_64_linux:  "bf1b6e9c25a735b6524a1b54fe5d7ae39c49c28867c774a2ea83d887e51bee3a"
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
