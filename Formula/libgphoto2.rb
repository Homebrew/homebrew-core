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
    sha256 arm64_ventura:  "688c529e85f9e34c624cfde0dddbcef5aebfeff2237954d8ce53ef60d444cced"
    sha256 arm64_monterey: "68c8f29614d57710c8d00f5ad526b848eaaf38c4d70ec77f8531283255ed2c1b"
    sha256 arm64_big_sur:  "e3744a3675a5f6b5727181755d126730bcc79a39545e6a0a1133a1e4d5a97e74"
    sha256 ventura:        "831c3e119f5e201b25799003a1a372b661c9235b15287d5b08ff5f1d157a07c7"
    sha256 monterey:       "d72b3a28421b921f1189717b8aa9cefb819e7d90fcd0029b8b2c4e354836023a"
    sha256 big_sur:        "54eb7a59f8fe1f56eafb31441f29c577e7685e39590cd8d3cfa59ee54c8c24b0"
    sha256 catalina:       "31adfaaaee016330cf07e8e9a71ccc4517a987038504d8a6992cb6bf2deea596"
    sha256 x86_64_linux:   "96e0c553d9c3d7d25ba2a73b35660403ada42e5bc2dc7f7b7be98e3acad846e2"
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
