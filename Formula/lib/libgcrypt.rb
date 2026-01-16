class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.2.tar.bz2"
  sha256 "6ba59dd192270e8c1d22ddb41a07d95dcdbc1f0fb02d03c4b54b235814330aac"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "089395cdfa4672500bb65546ec788b42a6b68a49b7f6ea6897d167686fa06988"
    sha256 cellar: :any,                 arm64_sequoia: "0c3b3de1c54c189bb222176beeeabcf8b8343fa2b3b734ba3985a9ed40e0f351"
    sha256 cellar: :any,                 arm64_sonoma:  "b697e48f0b790747905b0099c0d92f7b5fe14d8b3249b78d0224aed148ef46bb"
    sha256 cellar: :any,                 arm64_ventura: "7e1f03f93695a61a96743df753fbd25104f13c0c22ac8f402b0fbba0d4ff6a76"
    sha256 cellar: :any,                 sonoma:        "2285742bcb90d04600483669dc2b5e892aa13d17abf8b9ccf1209dcd40926413"
    sha256 cellar: :any,                 ventura:       "89714237fcc5a1a9048955278f3616a9f70a85d855447f97653af7b8682af837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "901904c550eeff8c756017dc758eb742bd722b3bad8f6fb5a5fc2b06042850dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312d572282fa287666e7c10e6828c4478c8562f095c9288599d8bfdd3d33e225"
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
