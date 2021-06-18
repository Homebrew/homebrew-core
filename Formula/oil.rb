class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.11.tar.gz"
  sha256 "0ae97bca30c8957156e77479132b954b63e1e47bfe284c628aa36ab01f66d089"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "27306bd8d63fc6a585124f2759a614197ba2b1cabd0efc06a7f6eca3539a2873"
    sha256 big_sur:       "7c0920ee0af6b53588b26b6ef53ce72001a4b14007107d395cfee61fbc4d3d83"
    sha256 catalina:      "0ff823bbbeddc607bd24bcc26bdb1ddd73d2cb98f0f7a332af2218a77f27885e"
    sha256 mojave:        "f293cf234e3f2a5dd92587608b88e3211715333025269c922b422493a0a6eff7"
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
