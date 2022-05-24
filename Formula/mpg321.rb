class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "https://mpg321.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "029006ddf0517aed22eeb084267dd6b2e74fc43f8a9a73488aea74fc4bc2321e"
    sha256 arm64_big_sur:  "ce333737749b9af60223dec4a4492daa66b2c12bdb144ea390648bc88df4b38c"
    sha256 monterey:       "e8745354e38c8e362bb289dab13ee28e8d9886fc0f7af9a1d4051a9aeb0ebf21"
    sha256 big_sur:        "8ee396f49f3bde62edb1e6376b292c0724a9b6c808d0b2e83c26bf351097f41a"
    sha256 catalina:       "4f93d83854a0072fca2ce326e46e7e068422464253f4981d3cf55b5e3ed9a4f0"
    sha256 x86_64_linux:   "287044834b3a9e9e0b5b5e060a3a2492fd47c686d97ac74ffe6a1dcc479c5e2f"
  end

  depends_on "libao"
  depends_on "libid3tag"
  depends_on "mad"

  # 1. Apple defines semun already. Skip redefining it to fix build errors.
  #    This is a homemade patch fashioned using deduction.
  # 2. Also a couple of IPV6 values are not defined on OSX that are needed.
  #    This patch was seen in the wild for an app called lscube:
  #       lscube.org/pipermail/lscube-commits/2009-March/000500.html [LOST LINK]
  # Both patches have been reported upstream here:
  # https://sourceforge.net/p/mpg321/patches/20/
  # Remove these at: Unknown.  These have not been merged as of 0.3.2.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/mpg321/0.3.2.patch"
    sha256 "a856292a913d3d94b3389ae7b1020d662e85bd4557d1a9d1c8ebe517978e62a1"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-mpg123-symlink",
                          "--enable-ipv6",
                          "--disable-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/mpg321", "--version"
  end
end
