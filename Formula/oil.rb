class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.6.tar.gz"
  sha256 "b024aabddd9b77bbc0cd1f2c64c132993917c543a0fd41bdbb8ae6a4f690f1bc"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "3df7db073f8172ed6215f23141c894da5038cb01ab21e9fa3963fdf85977ac28" => :big_sur
    sha256 "09995b74c7f608022a3b4255c615995bc23ad2da3ca334e9c19cefee5b69fb3d" => :arm64_big_sur
    sha256 "f768ace710ef8c63d699cb81765ab8aed700de33ce0451d92d03adaf28b270b1" => :catalina
    sha256 "e31eb9050a371c77ada60cbd6bc02a37b76aae54f9e65b2320d9ec4bda902554" => :mojave
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh -c 'shopt -q parse_backticks'"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil -c 'shopt -q parse_equals'"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
