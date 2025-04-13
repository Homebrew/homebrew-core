class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2"
  sha256 "09120c9867ce7f2081d6aaa1775386b98c2f2f246135761aae47d81f58685b9c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6010619edaf0b17877797dc4beb14c1ccb423833e864bf9e2990cf4c21373ce"
    sha256 cellar: :any,                 arm64_sonoma:  "7915e7cef1926e5d1613329f7972414c79824a5401034b01f858ed253dee0cbf"
    sha256 cellar: :any,                 arm64_ventura: "53cba38f74d4eedbd8c74935b4b35f567f8f68455b8df38d66e5244f155c2ac8"
    sha256 cellar: :any,                 sonoma:        "0b9a2f6ca55e36d113b8d3c2c6098fb0e66709624bf5d84aca682e26fb4da696"
    sha256 cellar: :any,                 ventura:       "a2e2f896a1d89c8e7cecde7ba2a7f9a7e7470700b5b2ae88db5d4e26e18b14a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9236852d8de37e61b114bb6085a94e2adfda926a41774682513435c898195fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ca7345d0a07b08c6802ff2d536235e5c8aa49592321faa4950611bb9ef8f87"
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
