class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.23/libgphoto2-2.5.23.tar.bz2"
  sha256 "d8af23364aa40fd8607f7e073df74e7ace05582f4ba13f1724d12d3c97e8852d"

  bottle do
    sha256 "40c6940be0084a5a5abfad2f5213ea738038db424199caa3ef2b4866494125b7" => :mojave
    sha256 "fa391a414d685195eac9e1b70a8e4682b7a633eb43e70ac9f1ff2ca7f52ce5d1" => :high_sierra
    sha256 "e527d28dcc0a31f39ed20360d2a3f0a7068090f6f6c7b89d267107449ce6b523" => :sierra
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end
