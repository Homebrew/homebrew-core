class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.2.tar.bz2"
  sha256 "7ce33c2492221a0436f96a8500215e9f3e3dcb5fd26a757cd415e7a843babd5e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a28d181fc09720c699b5fefe62d41b3c75ad8ae73a080c989faa2acf6925d06d"
    sha256 cellar: :any,                 arm64_sequoia: "8f05385898305e7f3f8717aead5162962b7266d1f25f8eb6b1f1aaf5ced87139"
    sha256 cellar: :any,                 arm64_sonoma:  "562d16658a0786b0be1ae3bb764ce4e66d9215d0ca0007d8df0c800fe192ab2b"
    sha256 cellar: :any,                 sonoma:        "72ec986ea68038405a419bfe5f646aa4b71f0e214517873d154b300b4ce71fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7154aabeee4d72b91369b7f7b9bfecd25c793fb4e4fcfadfc41b3f23197e012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941be22c944a367fc59d0dac07bce43ee16b3ea8b634389813bd9d2337a01926"
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
