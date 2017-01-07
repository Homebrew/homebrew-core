class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://handbrake.fr/rotation.php?file=HandBrake-1.0.1.tar.bz2"
  sha256 "af4badcdf56465abc798e5e11fe0e437e23ea89bbee20798408980a34c4d5876"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "fa7575ce0ac15726e60ae4053604b333bb3eabc030afaa6de5c0cea9d4dfec72" => :sierra
    sha256 "74169323e0cd9b053fcbb2f7e225c4c2d2ddb2eae0058328072ecbeee985d6d3" => :el_capitan
    sha256 "a8197b1eadd55487bff94a1d2ddcc596d22438e672074b7c47cb42d9099ca9cc" => :yosemite
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
