class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.3.tar.bz2"
  sha256 "8b0870897ac5ac67ded568dcfadf45969cfa8a6beb0fd60af2a9eadc2a3272aa"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "170e800538f420a2e11b58cc8561b592b4cda07d5e6b76bd0edded6ef8d33192"
    sha256 cellar: :any,                 arm64_sonoma:   "4cb7e27bd6c2531421aff6abe9a232ec6b6b074d70661ae2b2131992bea42845"
    sha256 cellar: :any,                 arm64_ventura:  "7ed0f3acffe52376da207b2257249c899ebc5bf601f9d503e43092400a991e16"
    sha256 cellar: :any,                 arm64_monterey: "ea034d81eb942145882668557e02d7d18460628af5c272d065dabd5a762dccf7"
    sha256 cellar: :any,                 sonoma:         "b76b7d12d56c2db70d895c3babc24d909a39cd1e5af742ebb746b8485a0a9440"
    sha256 cellar: :any,                 ventura:        "a632f697a152448256ec30b27cc46722ff734c8fbbb6e5d8976f1375e9f8fdfc"
    sha256 cellar: :any,                 monterey:       "fca7474127331adde4cb1d4b1ca2d1e796a222941a166c9ed905dd6e85f0f571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e3d7d971a9b062d191e91488455eab709c6435c171b9642fd839c5c6303250"
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
