class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.9.tar.gz"
  sha256 "49ae9c52b5af81b405455c19fe24089d701761da2c45d22164a99576ceedfbed"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "3b6f844c11905a3dbe1c5a4b78c62416fd047c399be7dcb5887d9357a79a7802" => :catalina
    sha256 "8bbc1229a48f1cedc29c54bd9ef15dca1e9e513e534b648e0ad8300c340e51e9" => :mojave
    sha256 "53f4b9429b90c0dfe84a759bd21f26e668ea19143424d141bfe83fcc83e76394" => :high_sierra
  end

  depends_on "ghostscript"

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
