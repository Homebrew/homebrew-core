class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.13.1.tar.gz"
  sha256 "1a022259081a41a4fbca4cb54c117c9fba8cf831f141a7011b141141c1b40451"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "38cbcbe68b1106c0eb80a85f0930b89b76dd1bebc015422107b27b1ab3a6f487"
    sha256 arm64_monterey: "bab54970876b45aa552a097ed6864a3fe55e3d1fec3ee5c64fd09bdb3c8b544a"
    sha256 arm64_big_sur:  "d79892e7b4983aa57452d9e0d3c91f8c3dbdccd0143422a1e0f741bb1f48e7cc"
    sha256 ventura:        "3513af30c70859d336b4b1bdee5ddbc16b14f2cc67f82eb0f40a7e1b393de6ca"
    sha256 monterey:       "faf4783ebddd6efbea8ace8dad184275922fd436b1a3333a8e565ed117ab1682"
    sha256 big_sur:        "43129416bce751fc6eba73a4199029ba2c708f3c20802788ef4976bcce52d421"
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
