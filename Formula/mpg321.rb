class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "https://mpg321.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "1da7ca02424159358e08a6fad616a94fa848a0a46eb5098147b8f2a2f2d90538"
    sha256 arm64_big_sur:  "0cde599f9f7a975ff76faddcdd85606f62445c2493e201db737916fd03ec907f"
    sha256 monterey:       "30e6b5eb8e967e4c2597d2e2c017f1a77704d42a54ddba774f7fd603c805b502"
    sha256 big_sur:        "f21a4649c7437144d8228ce229acf7dcd36541c8475ddc9e065bf62d7f501b35"
    sha256 catalina:       "fdea1076a22b6af12c33b02e9eb040fceb11d39ed2eaa7307574bf5331d8f8dc"
    sha256 mojave:         "d587b58200397ad4e8f7fa8c861e01c2c5e344d89a235e78d22fb7bd5ddf04f2"
    sha256 high_sierra:    "6a8f8f58c8bf02f99e8206a231fce4e9f2bd7333b888581dd1838246983d139f"
    sha256 sierra:         "a69f242f57e4211f96fa56f10573777204d5ed7d61cd7b35a04e0bbd33b9064e"
    sha256 el_capitan:     "6c8921b0703d2952b6038ce7097957c3c2bfe9b59c2d41b5caddc268e96b245d"
    sha256 yosemite:       "48b9ac480d966fc344c4867f3dcef7cd59be1440b11fe7d8280d51134a881f78"
    sha256 x86_64_linux:   "f0e6431c86cba77da50d3ea89267963a78b9e7e46edf95172f52c086b5313d76"
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
