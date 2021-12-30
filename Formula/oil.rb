class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.6.tar.gz"
  sha256 "62601d6acfa8102496d5eccf6b15c4e478e2a00ef085c5f90b8a5e1c1b919506"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1de410391ce072d746cec4130793f3fba708f386712786a07bdb1d37cb993beb"
    sha256 arm64_big_sur:  "2162fb1a806e94604a224b207320f14cb87c67c14bf7aa09e404578528ba287a"
    sha256 monterey:       "581595d6a6f72755c18c10201cdb57184fd2d871830c451bfec62601209b6b73"
    sha256 big_sur:        "9fe372c6e87396c953e93a71456918801f7dc1003db03c5efcac9dca66b5a44f"
    sha256 catalina:       "0472cedc1e4227ce6afa73ef103ce7e475a30ab56901bda9ddd20957c4aed162"
    sha256 x86_64_linux:   "6cbae7050be662b8f24fbb85848ca1bb83487603317e0ce09a90f9987b464249"
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
