class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.32.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.32.tar.gz"
  sha256 "8639dc4d1b21e232285cd483604afc4a6ee810710e00e579dbe9591681722b50"

  bottle do
    sha256 "f3181a7bb80610f8e0662e03ee980a03f6388c142e5b7b15eb97ad3b9b4690c9" => :high_sierra
    sha256 "ba06b4094577d77c2d515932e0bf0f3e1481f26dd307e655d28f8fba13fa8791" => :sierra
    sha256 "05d95e47cfa533c37fcbd4f4b54b9c9957d985d49852f397c6d78387fbe2c254" => :el_capitan
    sha256 "d11466ebdc722d370346cecf135a925e1f482f0d0bbbb424f821347134f52e64" => :yosemite
  end

  depends_on "python" => :optional

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
