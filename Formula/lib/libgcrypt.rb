class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.2.tar.bz2"
  sha256 "3b9c02a004b68c256add99701de00b383accccf37177e0d6c58289664cce0c03"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8929cd28f6dd1ede9dadee99e9e2889aa1a4c1de096bba23448ad1ebee7a7ab"
    sha256 cellar: :any,                 arm64_ventura:  "958511d2de063313f9682d62d67722878cc5c6758a201ae5385eb62e539f6a48"
    sha256 cellar: :any,                 arm64_monterey: "e09e21e188996fea1e67c6593a21407384ff3aceb99ef59f05877a2a77676d6a"
    sha256 cellar: :any,                 arm64_big_sur:  "14ac682551b4eb40d1b12f98a2cdcc3364f0d76859b6b16898b5b793b315337b"
    sha256 cellar: :any,                 sonoma:         "9faedeeb583f9aa13be9ef1e47ab65b81ad35eeaacefd6a475aff60ce6b6f9d3"
    sha256 cellar: :any,                 ventura:        "1cf13dcb5279b2d4254f22560a3cf80d9c06a1458937851849f2dace0110a23a"
    sha256 cellar: :any,                 monterey:       "d39c52e83364970eb4be218d141f75550d11d07dbca2f62b91dddf4b294ef467"
    sha256 cellar: :any,                 big_sur:        "fa4f1d4dec480ee6dbcde6023a3b7407e4330535c0bc777b27c3f403261965b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4cdae9d33f557d8cc4f4fb34a2078a5ab9b91b6cfe9fabfcb966a6e39807bd"
  end

  depends_on "libgpg-error"

  on_macos do
    # Fix for build failure on macOS. Reported upstream at:
    # https://dev.gnupg.org/T6442
    patch :DATA
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "make", "-C", "random", "rndjent.o", "rndjent.lo" }

    # Parallel builds work, but only when run as separate steps
    system "make"
    MachO.codesign!("#{buildpath}/tests/.libs/random") if OS.mac? && Hardware::CPU.arm?

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

__END__
diff --git a/random/rndgetentropy.c b/random/rndgetentropy.c
index 513da0b..d8eedce 100644
--- a/random/rndgetentropy.c
+++ b/random/rndgetentropy.c
@@ -81,27 +81,8 @@ _gcry_rndgetentropy_gather_random (void (*add)(const void*, size_t,
       do
         {
           _gcry_pre_syscall ();
-          if (fips_mode ())
-            {
-              /* DRBG chaining defined in SP 800-90A (rev 1) specify
-               * the upstream (kernel) DRBG needs to be reseeded for
-               * initialization of downstream (libgcrypt) DRBG. For this
-               * in RHEL, we repurposed the GRND_RANDOM flag of getrandom API.
-               * The libgcrypt DRBG is initialized with 48B of entropy, but
-               * the kernel can provide only 32B at a time after reseeding
-               * so we need to limit our requests to 32B here.
-               * This is clarified in IG 7.19 / IG D.K. for FIPS 140-2 / 3
-               * and might not be applicable on other FIPS modules not running
-               * RHEL kernel.
-               */
-              nbytes = length < 32 ? length : 32;
-              ret = getrandom (buffer, nbytes, GRND_RANDOM);
-            }
-          else
-            {
-              nbytes = length < sizeof (buffer) ? length : sizeof (buffer);
-              ret = getentropy (buffer, nbytes);
-            }
+          nbytes = length < sizeof (buffer) ? length : sizeof (buffer);
+          ret = getentropy (buffer, nbytes);
           _gcry_post_syscall ();
         }
       while (ret == -1 && errno == EINTR);
