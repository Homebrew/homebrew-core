class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.42.tar.gz"
  sha256 "c076fb4d029c74073f15c43361ef572cfb868407d347190ba834af3b1639b0e4"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_monterey: "dedf6d84629d5be425761bb16b49799dafa5beb62c4cd2e00338257529f1e029"
    sha256 arm64_big_sur:  "110beab8c6ba44b4b583a22a13c9ac2910a1a701d4fd2c9f652b5d58a7cd4d11"
    sha256 monterey:       "8ebd9135090f6be383c666f2d43351fa3ec02b33ef4a3bc9ea6dbeaa7ff7ae81"
    sha256 big_sur:        "a7b547fa40fd411d9bad470887ca3b5d7f4faf91167de926e14d4b05eb0b61b5"
    sha256 catalina:       "147c064a545b472d0a4107ecccfe6be9763f162d3c186f86d0a09dc49648b1b2"
    sha256 x86_64_linux:   "8ec80f6b042e696b991acd2a986647fcfc115996d5ce652be2dc8f98dced44d6"
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
