class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.1.tar.bz2"
  sha256 "24e91c9123a46c54e8371f3a3a2502f1198f2893fbfbf59af95bc1c21499b00e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be268e1e718212df254fb8b678adbcef8bad3994deb995566b8fdd7743e0b482"
    sha256 cellar: :any,                 arm64_sonoma:  "531de63827be5ab57b3b82dff1107af39bc50da502c38c3a504e864d11996c75"
    sha256 cellar: :any,                 arm64_ventura: "2ef2f9a5995d4ece50c45dddf2a373a1674a18569272067c653ae2840cc6744c"
    sha256 cellar: :any,                 sonoma:        "4097600d438cb3383fcad621f71a011c79b90b96a96c8a5591406d63b08f12e6"
    sha256 cellar: :any,                 ventura:       "f24441d156443abc7b2621c61acd68647f60c90cd381028be3cb9876155902e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc425dfd0efe384e0bac5647ea0fe058450c6a12852c100ddc1ece85dca5ac27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d943d57e65e44159873931d24de16762e527793bb0478b8cbd0580af31a2ed34"
  end

  depends_on "libgpg-error"

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
