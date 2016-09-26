class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.8.tar.gz"
  sha256 "65256af389823bbc4ee4d25bfd1cc19023ffc29ae9f9677f2d200fa6e98bc7a8"

  bottle do
    cellar :any
    sha256 "048d8746852724a7827998a26487fab440a7f75876f6394f9ba2d88be5344241" => :sierra
    sha256 "94c040c805847bf56bccaf077a0e7bf0632bb0340a1a62e1f491c8520a5d8236" => :el_capitan
    sha256 "0ddfdf1223b3cefd8aeecb4f9b83ae2a51e6786258d574f6f6da0e7f98be2456" => :yosemite
    sha256 "5ac963d62d71162de892a06d3e3b140592ade0096bd9a33cf0ad8644e78e7104" => :mavericks
  end

  depends_on "ghostscript"

  patch do
    url "https://github.com/Homebrew/formula-patches/raw/master/libspectre/libspectre-0.2.7-gs918.patch"
    sha256 "e4c186ddc6cebc92ee0aee24bc79c7f5fff147a0c0d9cadf7ebdc3906d44711c"
  end

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
