class Dirmngr < Formula
  desc "Server for managing certificate revocation lists"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  sha256 "d2280b8c314db80cdaf101211a47826734443436f5c3545cc1b614c50eaae6ff"
  revision 2

  bottle do
    sha256 "53434e2db3e40e72e2ed25d76a5e2ae70326825d2d57ee91138839612db3db37" => :el_capitan
    sha256 "ddc0de1dff6015fd5072c2da6e0173be8fedf29db27edd03c33a3275b842e402" => :yosemite
    sha256 "47fe29be8ca19eeb4d4a3e3434cd35ef7b13e1c1a9e8696f5ebd4434dc8cc062" => :mavericks
  end

  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "pth"

  patch :p0 do
    # patch by upstream developer to fix an API incompatibility with libgcrypt >=1.6.0
    # causing immediate segfault in dirmngr. see https://bugs.gnupg.org/gnupg/issue1590
    url "https://bugs.gnupg.org/gnupg/file419/dirmngr-pth-fix.patch"
    sha256 "0efbcf1e44177b3546fe318761c3386a11310a01c58a170ef60df366e5160beb"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  test do
    system "dirmngr-client", "--help"
    system "dirmngr", "--help"
  end
end
