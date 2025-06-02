class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.46.0.tar.gz"
  sha256 "02d9ff7b8458ef61731c3d355f854bbf461fd0a4d3563c51f1c1c7b00638050d"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d08a20cf16a9f69e925000085b4062501df3c8838b25284a7a5733608fd944a"
    sha256 cellar: :any,                 arm64_sonoma:  "bb33e3bd843674caaa950a8709d05642098e812eca15c31857a43433ed90ba25"
    sha256 cellar: :any,                 arm64_ventura: "3d828f7c89d6c86df8e446f236491d601568b57b7a921c8638bc7b2a624c4d9d"
    sha256 cellar: :any,                 sonoma:        "c2d900dfd371707c26fd4cb0cc39d1cacecfad46996c7221a7cc076f187d3d5f"
    sha256 cellar: :any,                 ventura:       "ba2d352ce10d31e30df0f902a726e7b57937768844a75452f93cb7cc7b80649f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41be5dc73da1641d3c1a717cf63080e5d905038afa6a0db9d672e5eb8a009595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db0ed1a87555ff2b1327d980ab335f6f1ee6c6008be640b16a3fe51b0b48ad2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs pixman-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
