class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.12.9.tar.gz"
  sha256 "3a406f4a0ab6b110ef5aa8b306aea1ce306ca51d068cdb1ed1754d5ab292ef10"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2079930421898c514a2da59fa6dfda59397f5db927c9f18394f66d29a637ae6d"
    sha256 arm64_monterey: "a7308a9553f7f55c0cda7182612c0875f8c6a4a17103705671a9831b79ffbc5a"
    sha256 arm64_big_sur:  "af1df7bb8ee26ce3cd7c6e142f6ea32b2da3c5b2f84fa4e2625456ef2d96f075"
    sha256 monterey:       "aaa395c37c92e5973470ecc6562efb8c26a1a60fa15b693633ad500c075dbbb5"
    sha256 big_sur:        "b5cae372631f127c873c1f39c048d5330420b6e7d48841db8f1d27a9522b2b0b"
    sha256 catalina:       "c68663d0b15935329bc228454102cd7db844a17bd305decb672f2dad3607d19e"
    sha256 x86_64_linux:   "5737d146a46cd681452de528d1e71800eaa533453ae06a4bf52fa5bcd74a7b6e"
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

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
