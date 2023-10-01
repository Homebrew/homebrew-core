class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.18.0.tar.gz"
  sha256 "bc87ed40618267dae8a260f4ddb99e22e4badfe4e268062e0b9fc139d3588930"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bc276b9884f67c70b7cdf53f8c5c4442dd9cc249946c26d2b8674bb00df56ee4"
    sha256 arm64_monterey: "6779fdb9ef9ec13afacb4fdecc05c5196bad29e7ea7fff27fcf9c6b94172470a"
    sha256 arm64_big_sur:  "d40895e0b9a2bfacd404dcfe14d0e3156d2c42106fd41566fa8b6f1f6f4cde2a"
    sha256 ventura:        "8f4746d059fe3242c2278db908f80ac6f3e5e1ee45fccb12dee2db63bc385f3c"
    sha256 monterey:       "03750b00b2a1a886074df5e2104d327cccd1278bb0484b3b3b7397a6fb020820"
    sha256 big_sur:        "e734ec95a432204f540d1c423c826d7dcfc19165feaca3242d652b54b7ae7de1"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
