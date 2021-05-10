class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.10.tar.gz"
  sha256 "ab81a3d8dbdd85ebfa949764021e31d0b0f4ee188c88b29241f2ed1fafc63d0e"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e20b14abe68ed567c8c8dbcc56bf2bd9f603b4de00d05d48d0c4918a620b90fd"
    sha256 big_sur:       "42218a5220582a34f86ff83050ca14c6b149f000c414e588140fffca340a3470"
    sha256 catalina:      "ecadf5766ba0d9111fdd5e0e91151ae4d3ba7f8527b65e4c772a8a167f1f3fd0"
    sha256 mojave:        "dd104737645bc99e0e024eca84a1b460de5d39a42a05fafffb5d8e6bd7041b1d"
  end

  depends_on "readline"

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
