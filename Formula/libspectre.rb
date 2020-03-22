class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.8.tar.gz"
  sha256 "65256af389823bbc4ee4d25bfd1cc19023ffc29ae9f9677f2d200fa6e98bc7a8"
  revision 11

  bottle do
    cellar :any
    sha256 "c6e2690dc1dc378d532abdd3e6cceffa196920c0f39847ed5381343cf91e83fa" => :catalina
    sha256 "a6607ac6042dbae8c0b1eb0c8583a635bc9492e13b4633e28705c9cd8ea9d33b" => :mojave
    sha256 "ea22f4d72de4ffd88f936a594c6a9c1c333a17df80b4abffc130ddefb3c4db8d" => :high_sierra
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
