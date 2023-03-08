class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.14.2.tar.gz"
  sha256 "993fcae34b9804d567030a11f59e271cc64ae33f4bd178c4dd161c65b69a4e63"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c9f92d8d391b561ed803518d6d2782564d69c1b4af24b245535192a9178dfba3"
    sha256 arm64_monterey: "198736096f1135c77bdb83e2bed8d30e6f999beae964f446f330ed111ba61c5b"
    sha256 arm64_big_sur:  "17bd14fc2404dad8b47827920582995e290b2bab09a9d47b867637edcf690632"
    sha256 ventura:        "2376227f31b34ee0cc59eb4dd4677474a35142e868a9a66a7f0e92da733c71b5"
    sha256 monterey:       "975b383160b4602e5f89375b0b3e5ec2f6f4a52e9b4e209c658941572110aa00"
    sha256 big_sur:        "7d286867a1fcc0b9a10587d5507d38a90c0251363637348bd15ff8173e488d1d"
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
