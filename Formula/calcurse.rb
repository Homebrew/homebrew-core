class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "http://calcurse.org/"
  url "http://calcurse.org/files/calcurse-4.0.0.tar.gz"
  sha256 "621b0019907618bd468f9c4dc1ce2186ee86254d3c9ade47dd2d7ab8e6656334"

  bottle do
    sha256 "efc4322d5103b6a2f8f93f5d7556459854245330bd3beaca923757502ff9733e" => :sierra
    sha256 "98598389661cd000b63a44a95bffd813883c52cc75564f4420ce37548f5340b8" => :el_capitan
    sha256 "037998bbb6d0c6393fe91fec579ca6d951021c4706e001cc3d79eb7287153ec9" => :yosemite
    sha256 "d8d136a8d35d2c41bebf2180ca6a8a45712b40e17109ba58a197601548ad3d1c" => :mavericks
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
