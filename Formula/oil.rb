class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.12.0.tar.gz"
  sha256 "fbae63f16f7028cb8035568016fe02d0dce497addd971b8dd66a9c83d0eae5eb"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "054eccd93d0820c4fa578836a30dbc711070d43b673e4fcf3eb8e5af10f8cd5a"
    sha256 arm64_big_sur:  "c9bc4710c1e0c717dd36e5999b73ad70ff61cced87f42ea27f3b9cd092885194"
    sha256 monterey:       "2c49b8eb56de551efa8b8b218392545a212d4d2bd73342ad82a1e1de0026400d"
    sha256 big_sur:        "2b7247289c70e31310208f98a9b3101c3828fd809afffca4e9e13826c34f0fa0"
    sha256 catalina:       "e2c3b214f8792b8f592e469b3b4e089b428c548b985871b0267d2dd97ff1c7da"
    sha256 x86_64_linux:   "fe6bda89f19150f6f318022de3c7e37f4f8590801dd05f480a58a22af2238adc"
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
