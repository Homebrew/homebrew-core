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
    sha256 arm64_ventura:  "c9d7b9ab1f4a7a23012380c0df944d2f3cf3146fe5f6ce582490a9592bcd586a"
    sha256 arm64_monterey: "b09ad3f7fd3ab00f39bb9588da64e30056009eb0c1db3db15cf77bc44e54e29d"
    sha256 arm64_big_sur:  "83cc8210b124bb2aeec5a9a38ba516fcbf06e56c87b43f2a586586c3975cb1f2"
    sha256 ventura:        "0c05687a36eb61f39f805d5b48b4439229f20ab198bad598de67386930aa1a6b"
    sha256 monterey:       "d504ae54ac96df318f6de915c9cdc70aa6a47d2753ce82c43dbe91a515b36922"
    sha256 big_sur:        "155ab8ee0ab388704f1a362d89dfefcadbe7ecdb75a1866471b494a68d2df2ce"
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
