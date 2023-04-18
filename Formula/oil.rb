class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.14.2.tar.gz"
  sha256 "993fcae34b9804d567030a11f59e271cc64ae33f4bd178c4dd161c65b69a4e63"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "008d367d1aca567fde8a976624337d4e415383d4f93dbb6fceb4669869c9b42c"
    sha256 arm64_monterey: "7ae8c386955d589bb89a97a0f3159eea567ac0fb0130c9725ff9380064f2f91b"
    sha256 arm64_big_sur:  "21c16970a1147b1ea45c5ab49668969981072e20ad402c56b57af93e992df660"
    sha256 ventura:        "b25011cfba4abd2cc0d5987e12d79a7b29e17ef8e8568f4d2a02275666bc1fb9"
    sha256 monterey:       "920c3a7e9c5fe8995531cb909370cf57006d406e2979026bbf7820102d6d7392"
    sha256 big_sur:        "6958ddfb8b42edcbfbe0e857585dd91267d59b26c44134c4a57cd2c0a7186379"
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
