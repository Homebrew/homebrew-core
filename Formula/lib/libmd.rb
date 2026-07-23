class Libmd < Formula
  desc "Message Digest functions from BSD systems"
  homepage "https://www.hadrons.org/software/libmd/"
  url "https://archive.hadrons.org/software/libmd/libmd-1.2.0.tar.xz"
  mirror "https://libbsd.freedesktop.org/releases/libmd-1.2.0.tar.xz"
  sha256 "ac15ffb8430502fbaccdec66c5a82ee0eab0b0f36220df56710feadfeb13d0a0"
  license all_of: ["BSD-3-Clause", "BSD-2-Clause", "ISC", "Beerware", :public_domain]

  livecheck do
    url "https://archive.hadrons.org/software/libmd/"
    regex(/href=.*?libmd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "724fae7568e4d980d58d5e4dd8b16df1bba6867b1b86b19b051506a5f3c2686f"
    sha256 cellar: :any,                 arm64_sequoia: "c31c4006f3500e54a24928f78209be6ceeb7cdeb2bce2e09e0c012e2f75e671e"
    sha256 cellar: :any,                 arm64_sonoma:  "9dff072fc11c4cceba0618e321315414aac84c3079da934e29cd75d4debcc0f2"
    sha256 cellar: :any,                 sonoma:        "6197fba0dd8a2a9b32bb252e0fefcc2f5d1a981d17ba0e404075c3549d18e8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df107088db7b9b9c7e8107005899123c9d530605e2de894742094771f850506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1a0983574b60ff431bd4c9e903440ce6e5336ad24e18cbaccb6852b07f332b"
  end

  head do
    url "https://git.hadrons.org/git/libmd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
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
