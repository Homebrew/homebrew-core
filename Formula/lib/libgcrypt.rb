class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.1.tar.bz2"
  sha256 "7df5c08d952ba33f9b6bdabdb06a61a78b2cf62d2122c2d1d03a91a79832aa3c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cff8b6a3c92ffd76aa26ccbcc13e21e10ca6b3b231ded3d35e81e38ed5b05a6d"
    sha256 cellar: :any,                 arm64_sequoia: "1e90fbea3e8a54c2309a5f54db60159cbf4ac34264e60040e31e48b02c1c9d8c"
    sha256 cellar: :any,                 arm64_sonoma:  "885a7de8758e4bd968dd91d1acbd4f090913dc7396aca96503c6fca2c7712001"
    sha256 cellar: :any,                 sonoma:        "41423fc76f133a106758d801991bcd20fcb0dfdc2eed8f1ccbcbb1b324481a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9910126e491fb609f3671bcdc0ca9d9aeeb633361dc65fae56def5b5a3d4b7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec18f27e8109b7fb873ad1ead6acb4150af9ffb6c3a2f9f40c6e80c28c73e67e"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-asm",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          *std_configure_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "make", "-C", "random", "rndjent.o", "rndjent.lo" }

    # Parallel builds work, but only when run as separate steps
    system "make"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
