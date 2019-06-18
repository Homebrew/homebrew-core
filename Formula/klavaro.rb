class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.05.tar.bz2"
  sha256 "fe82c6c108a3c40ab97902a8874c6d10fd891b4ff1accce757e5cba0e361dd10"
  revision 2

  bottle do
    sha256 "e7e5581d3c799500af68003a23c4c1235b24e86e1500b68ea9698977d1e03f96" => :mojave
    sha256 "42b361645e169c196e5cf3efe0dcc4dca90e1cb36bd6a3fa46b477b7b88b2a77" => :high_sierra
    sha256 "e169711632e0b63cdea433288dc29e6860cd52241cd7681afc7aea0eeb70c1ca" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_rf include
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
