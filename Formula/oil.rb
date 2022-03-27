class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.9.tar.gz"
  sha256 "e10b6de6da4bda27a012e0b5750a9bee8c7576bd0d75ec13385e1fcf01febafa"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a962b09107812fd470005454b80b4af0c5613cd076c30ce00fa4c0ed2d0b46dc"
    sha256 arm64_big_sur:  "9f36c0aa68dc103527a4013d3aa0f42738944af1bb5359e2902bbbdde401aaab"
    sha256 monterey:       "bdb43f10a5d2ba236374858cb0015d6ca9cff60afeeca62b7e55909955cfac1d"
    sha256 big_sur:        "ff7553cfea482c281cc2d9bf5622da03d1331e388577f69c0360add3611c4b62"
    sha256 catalina:       "74888b5412e87a771e8884c8fb71ca65d3978543a24e27a6e38fd4070fa81b67"
    sha256 x86_64_linux:   "81aa6313f8a38d3d79baed195673703abd615ef3c18fa8e5e7c704ae314172b5"
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
