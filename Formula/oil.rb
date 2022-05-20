class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.10.0.tar.gz"
  sha256 "7a4baeb886f02e9f10770bdabfb92a752b9861e999581d613d0fc3d4e9287911"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3f74e9a96414497c68116d936de9acad7140ffe8484dd36f2908250105b34389"
    sha256 arm64_big_sur:  "675f621c454aab4a1ffa5edb62fd686fff0f672df1c901865cc7e000dbb2e9d7"
    sha256 monterey:       "7024f1396846816b9650a9e0cf932a395930543447d8aca1966ab28a10aee2c6"
    sha256 big_sur:        "d5cc753481a5691b6c4f9ddf0d30a4bd5cb82bcca77f95e97b56b2c2269b827f"
    sha256 catalina:       "1337b6aa1f9be392874648117ccd2f79c86c529c12465d7bc10e559ec0d4dfcb"
    sha256 x86_64_linux:   "41ff1d7433893d66399af9a2cf43ffa8a30dc5f6953bb9e51e143c184cbf010c"
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
