class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.7.tar.gz"
  sha256 "e81b822a106beed14cf0fec70f1b890c690c2ffa150fa2eee41dc26518a6c3ec"
  revision 2

  bottle do
    cellar :any
    sha256 "79f1beae474d4c964555db602422c17cf59521d8a4753df00676b02a79cbbd80" => :el_capitan
    sha256 "761e89b0ed74ca24a6950fe789fbd18b47c3c7c318a9ddc8a1808b02b73a6342" => :yosemite
    sha256 "0e6bae9391fcbc3fd2c827e8a86b677ed7442f961a24de252fee6ba357cac827" => :mavericks
  end

  depends_on "ghostscript"

  patch do
    url "https://github.com/Homebrew/patches/raw/master/libspectre/libspectre-0.2.7-gs918.patch"
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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
