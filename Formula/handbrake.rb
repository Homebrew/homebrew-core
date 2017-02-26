class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://handbrake.fr/rotation.php?file=HandBrake-1.0.3.tar.bz2"
  sha256 "591fb489edd6146136f0a92f895c2098365f612ad308d5ff9dc83223ad73ed27"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "0a4ed5bf726d76c6728e9bce6e1b1ea2ea3ff2d3802f4b64c1fb25d551ceb390" => :sierra
    sha256 "2c93a7f98629c7d33fb8e25cd49d3e63f768c997cba9b828bd5c4b67ec941710" => :el_capitan
    sha256 "ab4ea7d8a76bf75710ca902f6b602afa7725791769c6d263ea5ed6b1d9e660c5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
