class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.4.tar.bz2"
  sha256 "d77f68f48879510e79a2f65977ccc68981781ea0923e5bdffac2a193ea3d660e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6531ea6476a9e9c35f5c9b5420779da758edac7f486ee97a2aad8a18ee5d6fec"
    sha256 cellar: :any, arm64_tahoe:       "18f7d112e7d1596592b3ef268bb223217cd97725659012c5c3a9041b2999f284"
    sha256 cellar: :any, arm64_sequoia:     "c314eec8280f768dba978c7c55a569d3944505d7d709285e4721f24ae765748c"
    sha256 cellar: :any, arm64_linux:       "969e21ed2fcdc94ddb61cb6418b3bd12b56681b8ae8e8b8c6b51ec0bd4ccb116"
    sha256 cellar: :any, x86_64_linux:      "41109424f2982ccaccab52cad5e543d8aac6331fbb1959b2a482ceb89868ad44"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-asm",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-libgpg-error-prefix=#{formula_opt_prefix("libgpg-error")}",
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
