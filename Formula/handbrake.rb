class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://handbrake.fr/rotation.php?file=HandBrake-1.0.7.tar.bz2"
  sha256 "ffdee112f0288f0146b965107956cd718408406b75db71c44d2188f5296e677f"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "7f0f99e6975890175999986542b4ec7dc1b89b3d7e12dbeb1c567e9c3e653812" => :sierra
    sha256 "9c92ca018e24891d4398323deb72302af3cf55abb5bcc842675f3cd9e0164d36" => :el_capitan
    sha256 "cb27e57954a6fe9c7b07a711bf9c7a7ea4d4c99989de76131209f6df590e0552" => :yosemite
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
