class Libmd < Formula
  desc "BSD Message Digest library"
  homepage "https://www.hadrons.org/software/libmd/"
  url "https://libbsd.freedesktop.org/releases/libmd-1.1.0.tar.xz"
  sha256 "1bd6aa42275313af3141c7cf2e5b964e8b1fd488025caf2f971f43b00776b332"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libmd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "dd432cf5a6edaf4bf4c5fe5ffbf129122c5691ee3c98b13b7b6c512b95e917d2"
    sha256 cellar: :any,                 arm64_sequoia:  "bbca49fa49f17de525e710aa6e8ae6cca1da2253e6b9eab21dc655389a5a81db"
    sha256 cellar: :any,                 arm64_sonoma:   "98337df7be937bfe745b53b62522cf81160032f945d744d879713a729acc8ab6"
    sha256 cellar: :any,                 arm64_ventura:  "02f452242f49ca67f98dff20e769e290db1d99c6d5874c067dafd8be7bfa0a92"
    sha256 cellar: :any,                 arm64_monterey: "fc0d8c70408cacab6b3b1f2567582ab2281fd308d7e2ce704042705dabe40241"
    sha256 cellar: :any,                 arm64_big_sur:  "bfd3a5595f509f3ebb3970c0c2a0e3b08569573ca1f406a8047565d26fb652dd"
    sha256 cellar: :any,                 sonoma:         "92750c60e0d59b9f5e9fd48f80031c957ae8d2f833dca196f1dfa9a36504cf05"
    sha256 cellar: :any,                 ventura:        "e81790c66cb480c6b411fca1e2adfded0e5c20ab12ec02e57e450bdb589539c3"
    sha256 cellar: :any,                 monterey:       "36a5e1ef679b99d090814f2fde15e9fb45d73afa26fc5ef75618c4ff85bf48dd"
    sha256 cellar: :any,                 big_sur:        "603212a43a289d57d2b541a3775d9a2c036b3813f2ca68640651b659f8dda490"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fcba0ca8cba980bd479183e6bb65765ea70990f7dc8c4258b0e1256de1070731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07679b6d5141498eaaab977d8501cf12219feb13a7ae040044561d5abece9af"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmd", "-o", "test"
    assert_equal "900150983cd24fb0d6963f7d28e17f72", shell_output("./test").chomp
  end
end
