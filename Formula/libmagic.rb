class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.35.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.35.tar.gz"
  sha256 "30c45e817440779be7aac523a905b123cba2a6ed0bf4f5439e1e99ba940b5546"

  bottle do
    sha256 "c3fe0254292ede89316f4f51c4e603065439e9d090d0d7a32d95ce9b10697fca" => :mojave
    sha256 "c8ff7d4f1248f71c8486290fa67539d4a011bb14e2e361dc610a5e914e7db2a0" => :high_sierra
    sha256 "cfd626e5f31452b0e482141f06b3bc56244c4e6298e752ea25196236d94ebc98" => :sierra
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
