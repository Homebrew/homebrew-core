class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.37.tar.gz"
  sha256 "e9c13967f7dd339a3c241b7710ba093560b9a33013491318e88e6b8b57bae07f"

  bottle do
    sha256 "e654f30906f89acee7a71bafc464d27876024fd795bbcbe0535285afce215ff0" => :catalina
    sha256 "d4bef4ec5fd234cd4fdc0650d7a2dba51fa9e5d421669db9fa8d2d466e20c98c" => :mojave
    sha256 "14eb5417f36b7ae1813a290c6004c880bd2c50498bc470a48dd9fb8cb489aa4e" => :high_sierra
    sha256 "c5cacee5081c405d14caa39c8e3768c6112c8f154c9e1ebbeabd081fff88f44b" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share/"misc/magic").install Dir["magic/Magdir/*"]

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>

      #include <magic.h>

      int main(int argc, char **argv) {
          magic_t cookie = magic_open(MAGIC_MIME_TYPE);
          assert(cookie != NULL);
          assert(magic_load(cookie, NULL) == 0);
          // Prints the MIME type of the file referenced by the first argument.
          puts(magic_file(cookie, argv[1]));
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmagic", "test.c", "-o", "test"
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
