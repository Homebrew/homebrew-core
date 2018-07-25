class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.34.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.34.tar.gz"
  sha256 "f15a50dbbfa83fec0bd1161e8e191b092ec832720e30cd14536e044ac623b20a"

  bottle do
    sha256 "bd5083a984a62056a9aa0e47997b8c02110e4c8c3cc5114a56fce6c02434c2db" => :high_sierra
    sha256 "4231cdb08d5090c66aa226aa618c9befaa29687e732e1ebd48a930096187daf5" => :sierra
    sha256 "02553f09e8f751547aaf5c98fd0210055472680840a86f9377bbd3712aea6096" => :el_capitan
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "python@2" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python@2"
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
