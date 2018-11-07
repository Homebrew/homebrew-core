class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 2

  bottle do
    cellar :any
    sha256 "71c22460f978f7fd9e7c971c05158974531a0b5a33e79d588f7cab4a8012782a" => :mojave
    sha256 "10a64160e7a8526fc9844b3e040a2d4fcf6d8b04b1cc77cce933be1e33098caf" => :high_sierra
    sha256 "843091f00f1759f133f07ceca406b985cf07371010c0e0b01497dd2de629d8d5" => :sierra
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "libtool"
  depends_on "m4"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "xz"

  def install
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "/usr/bin/make" # prevent hardcoding make path from superenv

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
