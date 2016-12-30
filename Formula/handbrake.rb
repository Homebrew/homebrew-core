class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://handbrake.fr/rotation.php?file=HandBrake-1.0.1.tar.bz2"
  sha256 "af4badcdf56465abc798e5e11fe0e437e23ea89bbee20798408980a34c4d5876"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "6d07325d6babfa3120477c6cf692ab20baa475527169a24c7d695b4794d6aca1" => :sierra
    sha256 "5070595cdc59b86daeea98cfbf50eb4160c7d852835f37e0bbdcd7ec97e564e4" => :el_capitan
    sha256 "82d26b3d35aee2fe88e4f867531895963a90fe5ed946eccae50fdd295180be0c" => :yosemite
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
