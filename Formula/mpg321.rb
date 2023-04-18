class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "https://mpg321.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 arm64_ventura:  "5121567767b2da54cd4eca9c38f941dcd99000c53e46c9e3e6029a82e54e5712"
    sha256 arm64_monterey: "aae6a0f70e06529f68c1f32ae77ab30d733993989aebd4680e49f84b3c26afe2"
    sha256 arm64_big_sur:  "f3ba496b39e008dfe0e2b92c4d5fcc55f3040eef0cf45bfb29eec86f618929de"
    sha256 ventura:        "dc2cc77c92a01c5fe94ad0fbc467302e47f38743e8a3ac4d66d25b3e38c19a6e"
    sha256 monterey:       "5c160696795a2cf4262e4183ca91e934c70828b6af8de77479972b3e640247e9"
    sha256 big_sur:        "8e0c58eb4f9a91375d28cf616563733a91baa1d06dd66317826d096c48a277a6"
    sha256 catalina:       "5ed70395deaaf283b53c951e3805df5300b19f0921e3844eb28f6176012bcd5c"
    sha256 x86_64_linux:   "a9e308f8bda99a7df745630013f69edf11302c6cea66428b3fb71cc99d12844c"
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
