class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.36.0.tar.gz"
  sha256 "1ca19c8d4d37682adfbc42741d24977903fec1169b4153ec05bb690d4acf9fae"

  bottle do
    cellar :any
    sha256 "ba7cd2b7be2df5b079a506d507ed4cbe5563258b98a1a6dd0ac832600bf258a2" => :mojave
    sha256 "8274aac0ad9775aaff37e1400d3659fdeec765db0381e142de873598075eb063" => :high_sierra
    sha256 "5271f5c3bb4c524047aaa1aaafa183908b6fa8ea8c5224fd30a04c53cd6c317d" => :sierra
    sha256 "47f660837d496427e5ff69f64d4b175f3dfa553580197dd06990803ba3eedc20" => :el_capitan
    sha256 "f92c0d581ecb7f5679d047c7e03ba17bfe169163dff5d10ac8c9ef4cb609bb0c" => :yosemite
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
