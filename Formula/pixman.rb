class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.38.4.tar.gz"
  sha256 "da66d6fd6e40aee70f7bd02e4f8f76fc3f006ec879d346bae6a723025cfbdde7"

  bottle do
    cellar :any
    sha256 "b6c450bc25f669720283d688536240fdd3dfe3a461dca3a0ed1867bac3b25e10" => :mojave
    sha256 "3c20a5cd8eb7346d0be2cb94f2954b8499509ce1ea1917a4f321285972cd1c4a" => :high_sierra
    sha256 "c4bd439460a62b4a953c28fcd8e2c7cda0c43fdb1133bb45cb1943fdc6e292f8" => :sierra
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
