class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.20/gphoto2-2.5.20.tar.bz2"
  sha256 "a36f03b50a8f040f185cbc757f957f03dc05a9210907199e6919ef3f970248f6"
  revision 1

  bottle do
    cellar :any
    sha256 "46bd976102f39a2b2a343eb5ec44db288d5f5bcb1a66caff9d64e56487d43642" => :mojave
    sha256 "c36a0a358efba0432699ecc445cf7585ed66410599d9bf4d22b05a2d515c4274" => :high_sierra
    sha256 "7bacc5db7d78e283d6d1a68d7b9fc0c5345c1047abe36f2ee89e06b7cf9260e8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
