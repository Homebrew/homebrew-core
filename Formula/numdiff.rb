class Numdiff < Formula
  desc "Putative files comparison tool"
  homepage "https://www.nongnu.org/numdiff"
  url "https://download.savannah.gnu.org/releases/numdiff/numdiff-5.9.0.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/numdiff/numdiff-5.9.0.tar.gz"
  sha256 "87284a117944723eebbf077f857a0a114d818f8b5b54d289d59e73581194f5ef"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/numdiff/"
    regex(/href=.*?numdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "109d8e428ace4ef6d70dc8ded51bec5d0510906e07c9ee4b3e32143f5054c82c"
    sha256 cellar: :any,                 arm64_monterey: "bdd0116d55164e3704b948d8ff69aa57e3553d7c635897d26e9d381ef67b6dea"
    sha256 cellar: :any,                 arm64_big_sur:  "ee93b5fbe264b96623ef6523a1dec871a5839d56823512da6a7811c06c367d5d"
    sha256 cellar: :any,                 ventura:        "5d48008fe3126fac107bc91308d83fffd39ef5c5e99a4150d52a95febfe573a7"
    sha256 cellar: :any,                 monterey:       "58e6c6f067c9a0ff39143bea741d68c5b50f06ddf7d66f5fbc35f4d691fcfd33"
    sha256 cellar: :any,                 big_sur:        "5acb0364a5f94b40b9f4d79c998910426855da30ea7f7b00241c135ffabdcb8e"
    sha256 cellar: :any,                 catalina:       "bb6458bc44ff4086cf74590c540dfce76014aaafdffd140b0a032b4ddbf17df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9334ab2846721f6a4b643e061dc1ef76f693a8a07f99f05dda3dfdc190165a9"
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug", "--disable-nls", "--enable-gmp",
           "--prefix=#{prefix}", "--libdir=#{lib}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "1 2\n"
    (testpath/"b").write "1.1 2.5\n"

    expected = <<~EOS
      ----------------
      ##1       #:1   <== 1
      ##1       #:1   ==> 1.1
      @ Absolute error = 1.0000000000e-1, Relative error = 1.0000000000e-1
      ##1       #:2   <== 2
      ##1       #:2   ==> 2.5
      @ Absolute error = 5.0000000000e-1, Relative error = 2.5000000000e-1

      +++  File "a" differs from file "b"
    EOS
    assert_equal expected, shell_output("#{bin}/numdiff a b", 1)
  end
end
