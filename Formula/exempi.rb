class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.4.3.tar.bz2"
  sha256 "bfd1d8ebffe07918a5bfc7a5130ff82486d35575827cae8d131b9fa1c0c29c6e"

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
