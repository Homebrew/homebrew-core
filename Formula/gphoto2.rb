class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.20/gphoto2-2.5.20.tar.bz2"
  sha256 "a36f03b50a8f040f185cbc757f957f03dc05a9210907199e6919ef3f970248f6"
  revision 1

  bottle do
    cellar :any
    sha256 "37fb8edbd5544c29cedcca1d5993edd79f864e0e48d2881a594967e220b9d011" => :mojave
    sha256 "5a806c3bab79874be998d3a47b0d0345cbedf17e3cc18ae0cd01cb881769155d" => :high_sierra
    sha256 "e9c413a70ddfac524438a2e8f59638483f8b2dfd975921e4cbdca35a0cdf0803" => :sierra
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
