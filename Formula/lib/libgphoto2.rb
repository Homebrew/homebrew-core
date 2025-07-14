class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.32/libgphoto2-2.5.32.tar.bz2"
  sha256 "02b29ab0bcfceda1c7f81c75ec7cb5e64d329cf4b8fd0fcd5bc5a89ff09561bc"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "7b1623d4b3344b30dfc4ad0d367aea6723c66885c7de2b8a90396592b2782553"
    sha256 arm64_sonoma:  "1d8ebf1c8da4b2faaa3ebae9db25ec16f0d7009ecfa375357559779e9e5c1b85"
    sha256 arm64_ventura: "633b4bf8082baa3098da2912e448b8b20a6f7002270e40fef9638823c8a3dd0c"
    sha256 sonoma:        "58a05c5466d4648e7378e92367daef9dc8f7610b3e491d7961923880b0e62230"
    sha256 ventura:       "ef675c4400ad1f1121922f3559667dc914923cef9c3b9138f26ce3babcd67bcc"
    sha256 arm64_linux:   "869891754e3bd0c041ed5b5bc70830e5d93f38fd7b5ecf87d622e59d05ccd3c2"
    sha256 x86_64_linux:  "bcf2a78a43ec66f4dd69664c3b96ef61c6bb2dfed8db64c2de573e0ad3530506"
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end
