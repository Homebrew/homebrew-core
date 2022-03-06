class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.29/libgphoto2-2.5.29.tar.bz2"
  sha256 "dbe3cefad8c634fc134d93467a33e242cb1030f0b9829deb9f1703f368ac027e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "5aa2e1b28cf3e4ab3f52f7b620ed62c39f27b5b6f517ed4ce83dd64b765537b5"
    sha256 arm64_big_sur:  "9f28d03949bb6a3eefadb6eff60c47dbb6da03af0f115206572a1db61244a41d"
    sha256 monterey:       "51c2b8ed04d8d0a1c149cafbaf9021910bd0436e51db235393c286bb2ffb9737"
    sha256 big_sur:        "e38c0e2412b13ab0b97560b68d9ad388e8ad4f2feca3fac668b1e93aa7f7d3aa"
    sha256 catalina:       "9140a050df9a92116d29bce5a5838ab6d0ade74ee91ff91df116c6d72d5ed040"
    sha256 x86_64_linux:   "ce5d924d57768461ca8bf88227aa28462d1d51df2e8536fe4cc975f16528c97a"
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
