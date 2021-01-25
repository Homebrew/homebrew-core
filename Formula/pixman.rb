class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.40.0.tar.gz"
  sha256 "6d200dec3740d9ec4ec8d1180e25779c00bc749f94278c8b9021f5534db223fc"
  license "LGPL-2.1"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0114710dd922d5e4839c9dea3b72cd5fbe6f00157dd63457c99ca15554cf8d7f" => :big_sur
    sha256 "da951aa8e872276034458036321dfa78e7c8b5c89b9de3844d3b546ff955c4c3" => :arm64_big_sur
    sha256 "1862e6826a4bedb97af8dcb9ab849c69754226ed92e5ee19267fa33ee96f94f8" => :catalina
    sha256 "70a476e6b14fdfa42188d3df2797f8c13f25bd633528164b0d42c5fb70dfb431" => :mojave
    sha256 "e5b78e3dca71370ccc06a013ebda8b9f1c2b89a238e2f3ef11a8086560e3c07b" => :high_sierra
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
