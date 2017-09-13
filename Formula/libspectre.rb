class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.8.tar.gz"
  sha256 "65256af389823bbc4ee4d25bfd1cc19023ffc29ae9f9677f2d200fa6e98bc7a8"
  revision 2

  bottle do
    cellar :any
    sha256 "54335fe8a5ecb8a3ecc4ae73b3b221daee1a51940a0970fa6b21a212e92a0df3" => :sierra
    sha256 "6c687edee091a796875e8392b4ad3be284f17addfc0f4944a58eddd7579c3c9e" => :el_capitan
    sha256 "e825e6b0965d5b592ae1b6f2097300e3082814f711ecb95186f527eb3fa2adfc" => :yosemite
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
