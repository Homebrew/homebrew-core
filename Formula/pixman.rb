class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.36.0.tar.gz"
  sha256 "1ca19c8d4d37682adfbc42741d24977903fec1169b4153ec05bb690d4acf9fae"

  bottle do
    cellar :any
    sha256 "2102c5d59a61940603b8746cff968e3ee9aecf245c0682aa89f1b793547d5268" => :mojave
    sha256 "104afb27acd98d592fdc50df39236fa592772a297aa70fc145bdd3019c471b62" => :high_sierra
    sha256 "d793a8b455c39dd082f625c5cf7547eedca9aaa184a0629a580c7af28743589c" => :sierra
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
