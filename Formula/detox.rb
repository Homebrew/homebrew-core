class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.5.tar.gz"
  sha256 "5d8b1eb53035589882f48316a88f50341bf98c284e8cd29dea74f680559e27cc"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "5636ac88e873246ab060735d242fe4059703c6bed30bea931c63757851739dab"
    sha256 arm64_big_sur:  "4e440bf09a205498b109d633d30216632df0657d0956ce85eb0c49224b3916e2"
    sha256 monterey:       "6dd49020e0f4d3deeb230e098df0b231da26aa6d2e65f58ae4fcf3d5e3f26340"
    sha256 big_sur:        "6e3621ec9c99de5bd834aeb7f1547282630355be71f74e973fe2918dba2ada85"
    sha256 catalina:       "622b6efed1e93de18b858e6c6c4d49dac0d6f568dcad9df35ea6a7ee61356b39"
    sha256 mojave:         "6201f2a5eb286f6f42f01d817f0eaa12c357049f6c97851984ba622aafd1641c"
    sha256 x86_64_linux:   "8fffea4f4d51f410ae7671e659c63b35aab854cb785dd71c0c26c58586145616"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
