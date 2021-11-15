class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.2.1.tar.gz"
  sha256 "ee3784bc8e7774f56ecd0e2ca6e3e11d38b373435115baf1f1aa0ca0bfd02bf2"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d4906f9955e78e9d96dff148bfbd46bd39496dabd88b7502e436c479e2217b0b"
    sha256 cellar: :any,                 arm64_big_sur:  "223cf167c2b2be056352ca25c6c78045f2f319fdee374310286e3e0383aad67e"
    sha256 cellar: :any,                 monterey:       "a3ad0c1cd8614931026eea4d6ec674c216571c75baefb6f2fe74fe7dd84afd02"
    sha256 cellar: :any,                 big_sur:        "c3855ed4bae9affb5007127469eda97fb91b395ca17f23639b4f3b08faed24cb"
    sha256 cellar: :any,                 catalina:       "51a594ab9b9237fadbf236b6b91e7dff12b1d762a9084a9ceefa38e368236175"
    sha256 cellar: :any,                 mojave:         "398471b49b724ac90cba0c87a44220adc0efbeb64b902429856531c263fa4404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d76f7c03d4eedb0bb87a94fb46380f3c8dc2213863c66ea55ae1d67b9c9464"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
