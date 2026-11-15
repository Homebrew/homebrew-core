class Libmd < Formula
  desc "Message Digest functions from BSD systems"
  homepage "https://www.hadrons.org/software/libmd/"
  url "https://archive.hadrons.org/software/libmd/libmd-1.3.0.tar.xz"
  mirror "https://libbsd.freedesktop.org/releases/libmd-1.3.0.tar.xz"
  sha256 "fc0f1eb6b6766470326f2c014693809190e67dba84274a6fbae9d4912d066706"
  license all_of: ["BSD-3-Clause", "BSD-2-Clause", "ISC", "Beerware", :public_domain]
  compatibility_version 1

  livecheck do
    url "https://archive.hadrons.org/software/libmd/"
    regex(/href=.*?libmd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "366d28c7ac75b795b94100726d9a38e66c97b669f5609ace8c251f842b69efe7"
    sha256 cellar: :any, arm64_tahoe:       "444402c6c05d552f31d5cd6acd6ea5654daa79b7d40d32d13aceeeb27e104713"
    sha256 cellar: :any, arm64_sequoia:     "2e70abfbbe3959958db7befb2c8b218781214290717ec10d97dea6c3e82021cb"
    sha256 cellar: :any, arm64_linux:       "64e7579f92d26396662dc6f7724c4d5837656ea7997a2c48e9d83ecdcb95f458"
    sha256 cellar: :any, x86_64_linux:      "934faaf308977199217ed9d52185bea45a7426ab03b68f4f369d1c1583e59bdb"
  end

  head do
    url "https://git.hadrons.org/git/libmd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deny_network_access!

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
