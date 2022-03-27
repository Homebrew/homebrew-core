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
    sha256 arm64_monterey: "917249eaf03709f657c72ac3aab547026977d22d8e3cb3e425c4d790747ec518"
    sha256 arm64_big_sur:  "af815a92503e1f696c89ba6df78f939c3c50fdbc866f31a4160627efd048f1e7"
    sha256 monterey:       "d44ac1ea0cd44092438d4f4c1f4fc41f45faecd266da2ff392703908cf7dd08b"
    sha256 big_sur:        "bd5079f77e06fe6957d9e7b1cbfb854ebb507944bde2c873c4297fb1aabf54d9"
    sha256 catalina:       "5a213a1716440e4fce72f77052082575bee7d555ee9f454b1c1672cd8ee42989"
    sha256 x86_64_linux:   "33b11ce72715577fb4c2cc940014a0822e00aa84d623e3dc8d43c14bec390b19"
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
