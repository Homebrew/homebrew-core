class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.43.tar.gz"
  sha256 "8c8015e91ae0e8d0321d94c78239892ef9dbc70c4ade0008c0e95894abfb1991"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_ventura:  "3582dd895b1952ed0c9071ab9a1dd7b59c8921c1c5941f6fc1bed4d346ecccd4"
    sha256 arm64_monterey: "d90f8e7fc431a98c90512506dd89e39f50b566329efbefa83a1926392a4d2454"
    sha256 arm64_big_sur:  "dc07c487e28ec071a5e001504062dd742c8dc87ee14c9d28fb95024760c5c902"
    sha256 ventura:        "b8382b7cea4429eeba27d5f7fb7d6132e265d0cd1e2aebc2e0e54b70000872c4"
    sha256 monterey:       "1de7baf672db48278eab882713c696e07ef0fbd5d410c6fa20975ee80b52497f"
    sha256 big_sur:        "77f8eee4e9b52d34121b0193d4cc697d72400826dbb76736e68fac60cc3e230a"
    sha256 catalina:       "0755f82d6b3e7258ec880a84d734a0eb8ad49e362c64a8a196be0c5b50832475"
    sha256 x86_64_linux:   "2e5ec384617e10bb3434063a9ce4c02a487324e14f9229126d8b4d5e97124dbc"
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
