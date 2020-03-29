class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.38.tar.gz"
  sha256 "593c2ffc2ab349c5aea0f55fedfe4d681737b6b62376a9b3ad1e77b2cc19fa34"

  bottle do
    sha256 "b62d63057eeb729667d6155b5d79da97742d5656d9995359f6d945b6109ce2ef" => :catalina
    sha256 "0b6136c04b93fbec36326c88f7443e66d9faa209dedab7346f2b6ba015cd1ffe" => :mojave
    sha256 "8bf0dd3733907457d0102dd8e6e28ddaea304cd7eb59e5e559145f50046dd784" => :high_sierra
  end

  uses_from_macos "zlib"

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
