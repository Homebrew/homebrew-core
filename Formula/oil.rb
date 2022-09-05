class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.12.5.tar.gz"
  sha256 "e7fad0b14deb64fa28e9db40060dcfa8288f04f0f019acf8d15fc85b60ea5770"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "18111214c1aa2952f679e5ee36af475ac8d58f7267d5a41bde38c465d2c3ac1a"
    sha256 arm64_big_sur:  "f6c6f5eb33175a6700f5e2b38d577081a29a6c6f9a4692eb4c1e03378257b328"
    sha256 monterey:       "92711ac44e8d1ff4e60add798fdc9daec9750a503f5081390d0e5e90b186fe56"
    sha256 big_sur:        "2d2d0accfc37886e0cff9259491ecb5979a420fb54d7b98f71f35728931e9e58"
    sha256 catalina:       "15f5fb64867d76b4c74b8bece87235f92dd6b8793e9244ea5267e1e91a9e38ad"
    sha256 x86_64_linux:   "264202aeba3d8abcf3f1e4f751eebfdef6e4d61779828b35519e3949b41cc1dc"
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
