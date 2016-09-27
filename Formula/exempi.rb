class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.3.0.tar.bz2"
  sha256 "d89aed355e6d38b8525ffeaffe592b362fec3a8306a1d8116625908af8d89949"

  bottle do
    cellar :any
    sha256 "9f5de7fcc210405533becdd6a25595df115674aa5828596242562cdac0681e71" => :sierra
    sha256 "8445c3fe80c44a8b7589415b797704340ec865e1c572a728f753c33ebeeec141" => :el_capitan
    sha256 "02f7d164840640fef806abf0b22e53ab4e479189fe077ecf2bcc4f7fac812164" => :yosemite
    sha256 "204ac5dd569a2f54fe13a586a1fbc011b96de1a58531dc4d9694d452148bd236" => :mavericks
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
