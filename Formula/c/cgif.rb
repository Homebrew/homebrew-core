class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d5e603309176334406d7e4f0063ed96924fe9b0368e8037df2614c0df67bb41b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "934ef90557be33d46d6fdac7ac1d49bf96a22f802113415fbda84bf3cca86c99"
    sha256 cellar: :any,                 arm64_sequoia: "6f06564b5b60edb3d75b4231148c0830a6b592bb63bd96d2f6e317059146727e"
    sha256 cellar: :any,                 arm64_sonoma:  "2738b246f0ee2f48731ff58b6db06bb2212cbf8c957af19c8acf424408ad6fa6"
    sha256 cellar: :any,                 sonoma:        "6d437fa9f6ac96eb2fdd69041229db21a58e3edb114c39237e9cc8ce1312c6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c818912c75c81835494a2ab27f557162617fe6dc9ba6ebeed87a9e51313db8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d1c0d0963842934dbc8dfb39973c9b4b84844648a4e35a677f900675728f0e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"try.c").write <<~C
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    C
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
