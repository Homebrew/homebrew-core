class Libmd < Formula
  desc "BSD Message Digest library"
  homepage "https://www.hadrons.org/software/libmd/"
  url "https://libbsd.freedesktop.org/releases/libmd-1.0.4.tar.xz"
  sha256 "f51c921042e34beddeded4b75557656559cf5b1f2448033b4c1eec11c07e530f"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libmd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c8f94c04ca398bca1dd9d27512ae308e110f6dbf0c8a86761720c3e288c8a01"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>
      #include <md5.h>

      int main() {
          MD5_CTX ctx;
          uint8_t results[MD5_DIGEST_LENGTH];
          char *buf;
          buf = "abc";
          int n;
          n = strlen(buf);
          MD5Init(&ctx);
          MD5Update(&ctx, (uint8_t *)buf, n);
          MD5Final(results, &ctx);
          for (n = 0; n < MD5_DIGEST_LENGTH; n++)
              printf("%02x", results[n]);
          putchar('\\n');
          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmd", "-o", "test"
    assert_equal "900150983cd24fb0d6963f7d28e17f72", shell_output("./test").chomp
  end
end
