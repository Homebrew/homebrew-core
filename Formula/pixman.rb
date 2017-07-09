class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"
  revision 1

  bottle do
    cellar :any
    sha256 "5271f5c3bb4c524047aaa1aaafa183908b6fa8ea8c5224fd30a04c53cd6c317d" => :sierra
    sha256 "47f660837d496427e5ff69f64d4b175f3dfa553580197dd06990803ba3eedc20" => :el_capitan
    sha256 "f92c0d581ecb7f5679d047c7e03ba17bfe169163dff5d10ac8c9ef4cb609bb0c" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
