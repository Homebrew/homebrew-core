class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.44.tar.gz"
  sha256 "3751c7fba8dbc831cb8d7cc8aff21035459b8ce5155ef8b0880a27d028475f3b"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_ventura:  "d9336a1be44d8c6307cc49aebebf15b61b8b184d09a0de7a8a1a22f935a495ce"
    sha256 arm64_monterey: "4a50a08c650c6b18e670b1dfa03967190c663123f068fdd7c9b8dc2485067573"
    sha256 arm64_big_sur:  "efa77cbf2767dc77caca083c6cdda108b63b1a94a2b292842c6d6c0e7bf66cd8"
    sha256 ventura:        "b1b371f7431e0a18bfd095677271dac7a5056ea0990fcecb1924a4d73ab64a5a"
    sha256 monterey:       "6b56d0677ddf627f62410682b80c900f6aca24963000d83f7acc9148bdd91769"
    sha256 big_sur:        "ea9ea2b9eeaa22ae738c743be1e3fbd00b01193d675f93f1dbaaeadbac770137"
    sha256 x86_64_linux:   "7a7951e67423493720b99273788ab46042209b802ca2006d20acdbccd67185a5"
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
