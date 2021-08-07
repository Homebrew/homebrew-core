class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.40.tar.gz"
  sha256 "167321f43c148a553f68a0ea7f579821ef3b11c27b8cbe158e4df897e4a5dd57"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_big_sur: "9355e04e8f290664fa63d03abdaadc7da71dc6f57890cf92acb3f0a138f86c26"
    sha256 big_sur:       "e8524f59c4be8ea41ecf784e236f19357ea42b6e6160348f96ba948699d297f8"
    sha256 catalina:      "4d242598d9d51562b4f02edb901902bc62c52c834cb6bea67ad957aeaa594b1c"
    sha256 mojave:        "06639c7f11f68169ea2709f9fc96f4417eb9e21f8f4b0c88a96ccc26528bed9f"
    sha256 x86_64_linux:  "44724a1e6f4fd242b8697a779dd52dfba2cfe51af463a867d2f9700145c51076"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmagic", "-o", "test"
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
