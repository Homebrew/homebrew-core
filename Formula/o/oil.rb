class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.20.0.tar.gz"
  sha256 "f19e055679571e7c3da32d53c479e5a9acc8547ae28c2e03983109cc7b84fdca"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4f3303a34065bb073800c15f1089b3c45a14bcff7cb9d1e876836ef91b511aa4"
    sha256 arm64_ventura:  "4e43dc696a345d6e44adacfa8bcf05f9fbc8686c8e2e8fd9fa4f2e6e4cc25e49"
    sha256 arm64_monterey: "e9e340494f10ba097eb145ae26a96ff96af1b7dcb37784641a79fb078977a851"
    sha256 sonoma:         "1b1f2a075f825fcda3f1cab4dd8a50235ac1e553e6a592d04b02810c096fc165"
    sha256 ventura:        "d689469b7cbb6bcb282cfd79550b7e80ae978751f3910b636d7cdade5d1ef5a1"
    sha256 monterey:       "cb6a139a3939187d978b1cd067d12f4a43089d3a0e7f67d49af28b319915a98e"
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
