class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.35.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.35.tar.gz"
  sha256 "30c45e817440779be7aac523a905b123cba2a6ed0bf4f5439e1e99ba940b5546"

  bottle do
    rebuild 1
    sha256 "0fd1814daaab8aaef0f6c9bbfac4eb3d251def6778e6d59bd4e3df3dd5def9bb" => :mojave
    sha256 "ba9b9ee461f6a5de3618f462a13e1c2aa83185bd0cf8cc759788577f2d2b39fe" => :high_sierra
    sha256 "0df405f6459085824e349764bbb324da02b6bac817a2d307317e713045c7972b" => :sierra
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
