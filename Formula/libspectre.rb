class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.8.tar.gz"
  sha256 "65256af389823bbc4ee4d25bfd1cc19023ffc29ae9f9677f2d200fa6e98bc7a8"
  revision 7

  bottle do
    cellar :any
    sha256 "14d107a48c6f8bc78134eb5b7d36f89f17a0efd212c1331c4a5ccf2b6f158a12" => :mojave
    sha256 "52be82741ea6cbbc203f3d6c91c696a5ce286b6e6c48df0293585dd1ab904d6b" => :high_sierra
    sha256 "8cd6ea1b86def695138d1fadf32e6019719a4ec095a7aa3059fbed758e83d25c" => :sierra
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
