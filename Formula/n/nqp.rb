class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.12/nqp-2025.12.tar.gz"
  sha256 "074147578bfc0d2f91a6702270517803ff4e960e9f175dfe14b00eee6febc0c6"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "45a8f05bce3b66edf18b718fb61eef8f24159e31ae6b304ccf6a84369491ca5a"
    sha256 arm64_sequoia: "90e98c7f3c95bc04e504c482dad3f685e4620425ad58891d27e8716aff942c66"
    sha256 arm64_sonoma:  "976735c3df04cce2ba4950cdf2b477bb1837c6ccc1dcb2cc974768aaff5a0fdc"
    sha256 sonoma:        "f942154bd19511cc8c8a8236b0e7cdabd0eb78ab0c418670ec8e9d9e6ec4dece"
    sha256 arm64_linux:   "cf54497ba5dc7eef1433fe6207d49c5c0f806ecff86271a3ea512c34cc7fa773"
    sha256 x86_64_linux:  "7acdada80c26daf2a5c82a582adfe1319d5001f91fb40d4226d97ec3ee3376b7"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
