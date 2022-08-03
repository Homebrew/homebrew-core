class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.30/libgphoto2-2.5.30.tar.bz2"
  sha256 "ee61a1dac6ad5cf711d114e06b90a6d431961a6e7ec59f4b757a7cd77b1c0fb4"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "5bbacbc68e2cb4480a005fe67908e559b2c25b41778a6aad2415d30fc4623786"
    sha256 arm64_big_sur:  "8b455e2a210347a034e440644aa64c2c4e60f14d0a5ca3302a3e22ce22fb31da"
    sha256 monterey:       "828419c3be2abe84e736f28093c66877447cce003113f5c9695424ff14989d31"
    sha256 big_sur:        "0895331bf36a90c79cd3daa7c4da7d57ab65848d4e6f63c22023265dd9d58075"
    sha256 catalina:       "89dc25fb01c66d3cddc5b760377cf4d6584632da607e4d81265df594128cabe0"
    sha256 x86_64_linux:   "aac387487ec7acc0d9f1e7f13874bdb40ace2df1b1b576839ab4ab821d6d6252"
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libtool"
  depends_on "libusb-compat"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
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
