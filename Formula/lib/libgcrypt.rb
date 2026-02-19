class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.0.tar.bz2"
  sha256 "0311454e678189bad62a7e9402a9dd793025efff6e7449898616e2fc75e0f4f5"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16322b7413313ab8d0153e7de12534f030c69993a540168773b37e3aa20a56ad"
    sha256 cellar: :any,                 arm64_sequoia: "ecb9f091b6b819e7fa659d50edd7a8eebc46b5c00d486f91a0cb5ce91bbceef2"
    sha256 cellar: :any,                 arm64_sonoma:  "0e03d89e6feff9b8bf59a40a35a1d45cbfa287bfc648ade1b591757ea1339afb"
    sha256 cellar: :any,                 sonoma:        "ea6683e879f359926d7825da3063be268c030a2a6356a89099076148b6db1786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c76175d2eeceac7421eb666cdbc047dba5ab6df69a0ebfcee6e191ea0b35eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b418fa5f73cb4b901b6b3b56e49708c36f499daa1998442c1523e8693c5bb580"
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
