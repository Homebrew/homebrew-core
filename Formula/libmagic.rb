class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.31.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.31.tar.gz"
  sha256 "09c588dac9cff4baa054f51a36141793bcf64926edc909594111ceae60fce4ee"

  bottle do
    sha256 "6a7e572c28d4c00208f932be8dbd563dfd0c8bd3105dcab8d4fb5a6030040075" => :sierra
    sha256 "204d00e32a1a05814b199e4786bcc66e362d2105b16f1765d860f0121a62c250" => :el_capitan
    sha256 "beedeaab3dde42a38c75203af104d82872de5f4bceec31ac8308a3ccec24ae2c" => :yosemite
  end

  depends_on :python => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
