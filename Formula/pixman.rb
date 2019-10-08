class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.38.4.tar.gz"
  sha256 "da66d6fd6e40aee70f7bd02e4f8f76fc3f006ec879d346bae6a723025cfbdde7"

  bottle do
    cellar :any
    sha256 "3b56eb903b40382b7f52a82b811d07e80d316d855963aeff3b977d8225df26a4" => :catalina
    sha256 "3990b771ee29451c8a9bcb6cb077205ae08adc0d5af2faebf29197d13c36a51a" => :mojave
    sha256 "d383ddee57685391ea55033e6fccdca0352a898cbc4c75be40d7b5dc7c312916" => :high_sierra
    sha256 "005ab5564c93b757494692b1f0e52d50414058ba4674b4e3e4d9fdd30f8ee8f2" => :sierra
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
