class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.03.tar.bz2"
  sha256 "e0959f21e54e7f4700042a3a14987a7f8fc898701eab4f721ebcf4559a2c87b5"
  revision 1

  bottle do
    sha256 "7c0fc628a833ff67ec8a2af37ed385b6592ef7430337066c4ab54a8fb5380d1f" => :mojave
    sha256 "de9f3cad2e98abd81d4c9597c3a90dd502aa2ac1586ef49f8f55f3a255d23654" => :high_sierra
    sha256 "25a171b81e8e90d3c92625e89567abcf8ca6b8f326189e40d90714844bbbfa89" => :sierra
    sha256 "298080d48f362d502364a1048a6dceb581137c918da31d68d526ffcc14118d64" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
