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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "159d4661e6477b40c07ad7fd1b9832b8bfd1dfa0664a137b4ff7160c360e0c36"
    sha256 cellar: :any,                 arm64_monterey: "176db8960cd4ac83cf0f5145c3b1f7560ac239c867a2b3b41127e5badd238a38"
    sha256 cellar: :any,                 arm64_big_sur:  "4251c8ad6b6962dddba3270630943a53779af7eaf7b7963be34f5f3de7b14667"
    sha256 cellar: :any,                 ventura:        "897b410369a68b9a2db954519ace1d396cac501669d1890534754cb6a7e6f77b"
    sha256 cellar: :any,                 monterey:       "051da8fdcf3a6907760fd2983e9351d529a1a28d4f48ab32a942a232a9fe7fdf"
    sha256 cellar: :any,                 big_sur:        "1aa4b3d7c3fe5ad30d0711d045ca94e05a6fed6f928cdf11ac80acfc1fb31928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10df9063da043dc8dc8a2b5b0018f2fc7f4f055fe9ee5d7ad2640c26472e877f"
  end

  # build patch, https://github.com/macports/macports-ports/blob/master/devel/libmd/files/patch-symbol-alias.diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62ea945/libmd/patch-symbol-alias.diff"
    sha256 "a9bb67cbc2243d12fe81b6c9f998dddbe2f58f11570749f98ee23b07d9a02d53"
  end

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
