class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.11.0.tar.gz"
  sha256 "209ad011736585f85723672ab8f8ecac73f325015eef04eb66ec3b9989dd4ef4"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0dbe9856e2d5748dcfb96905dd6ac7c9c6a36b0cc595da44a29e1b30347bd6b1"
    sha256 arm64_big_sur:  "14537f9a4888cd144c9b64073dd5b023b9bd42c1d37c98463661953f9ec2275d"
    sha256 monterey:       "8efce3552e3405740fe2ecfb7e7c9cbac22beece9ea0d5f5d345890e84c2faec"
    sha256 big_sur:        "5d620f8a9386bdc3dfe95a6a26e89bbdd4442be7270888c84ad1feb6c225abc0"
    sha256 catalina:       "172ab76f8a84c98a3162c61ef0f8d51ad3755eb2c3140a1233d0f19e2a7dea41"
    sha256 x86_64_linux:   "09f731257bedacd2a6d189895025594b6103c80b35b0b02370833bae3b5068a4"
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
