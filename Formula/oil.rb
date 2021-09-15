class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.0.tar.gz"
  sha256 "6fe2ca27d1b1dfe922f7bece1fa88cd81357c6b95ad367420443dd06655da94a"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d9301c90b0d28c5a1541574e65f0144f77c438a6d5715644cb55f0d1570d1d66"
    sha256 big_sur:       "642c4c5d339fcec26617a506e2ba289764adda9157e2eb11809501271acbd056"
    sha256 catalina:      "b0e1f7765ce1412d4fc53ee716025a9ed3128592c0d36d2170f62f5c42c69aa0"
    sha256 mojave:        "81569f8eeec31603af6004d9f7609305a7e24cace91e800041f6be6fc8544749"
    sha256 x86_64_linux:  "00fc66056910079cce9ffdbf08077ba677376d44213bbaabdd65d71109766c9d"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
