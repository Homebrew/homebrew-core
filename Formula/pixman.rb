class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.40.0.tar.gz"
  sha256 "6d200dec3740d9ec4ec8d1180e25779c00bc749f94278c8b9021f5534db223fc"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3dbb0582d3c6fcb87fc1d99a42064e8b81d409951ba7b863c2482957792f837b"
    sha256 cellar: :any,                 arm64_big_sur:  "da951aa8e872276034458036321dfa78e7c8b5c89b9de3844d3b546ff955c4c3"
    sha256 cellar: :any,                 monterey:       "300fc41cc99dfc7ba11862149f9cb88ab9976200bf88b5b944ff09796ed05f40"
    sha256 cellar: :any,                 big_sur:        "0114710dd922d5e4839c9dea3b72cd5fbe6f00157dd63457c99ca15554cf8d7f"
    sha256 cellar: :any,                 catalina:       "1862e6826a4bedb97af8dcb9ab849c69754226ed92e5ee19267fa33ee96f94f8"
    sha256 cellar: :any,                 mojave:         "70a476e6b14fdfa42188d3df2797f8c13f25bd633528164b0d42c5fb70dfb431"
    sha256 cellar: :any,                 high_sierra:    "e5b78e3dca71370ccc06a013ebda8b9f1c2b89a238e2f3ef11a8086560e3c07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24ecddb5e7fe12c7a0b4458304542b4bacb1de51966f8f33d9dfdf9bd0c2b00"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
