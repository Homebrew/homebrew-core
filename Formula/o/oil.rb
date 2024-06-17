class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.22.0.tar.gz"
  sha256 "69b3f66d2d54059513355522198365038629eb5961216cd8481686cf818a7131"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e429bff192b3c095b6bc5756f07a6499bae832eac0f055f519d55c60d4963c4a"
    sha256 arm64_ventura:  "d845e1bc46e684e3675a521134b70a3765759334a49647eb31aac929cf011c7c"
    sha256 arm64_monterey: "61d3bc3aa2960c903cb4c8db235cbd8f75e890847e3333e291809329e43e606d"
    sha256 sonoma:         "75778c951ee57305f2ba5990631ded8b2bf11e94903464aa1439aebe6d27167a"
    sha256 ventura:        "173d6c29e86a6658caea9990e0a45803a0d7b30e766e1c7cf5c0fbb1f1c8d44d"
    sha256 monterey:       "2491449ded44d3876a21f0bc0b4b707c8fee6afffa24baedd3b733f56b5e25cf"
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
