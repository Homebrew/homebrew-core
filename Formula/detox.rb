class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.5.tar.gz"
  sha256 "5d8b1eb53035589882f48316a88f50341bf98c284e8cd29dea74f680559e27cc"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "c5d044cb0c37842930ac1df025c90c16103db60be6a22d6d1785d078376df9af"
    sha256 big_sur:       "c9ccb8e34c4ff9871a99f164ffb8ca6d4dafd3aaae38747cc6d14d3d2ddfbd68"
    sha256 catalina:      "c12b62b1cd2e3590663a9d34f89a4a9ba4ac550af208ecae0ad60c6811e124a6"
    sha256 mojave:        "2e9e5746c4d1c114b9b74627cf281171cd036deb78abc0ac576d1ba23e121ce6"
    sha256 x86_64_linux:  "57c3f39f5ac42aa4f890d4507ca4bb154ce55849b991e63afc9122b32658d425"
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
