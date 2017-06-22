class Dirmngr < Formula
  desc "Server for managing certificate revocation lists"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  sha256 "d2280b8c314db80cdaf101211a47826734443436f5c3545cc1b614c50eaae6ff"
  revision 3

  bottle do
    rebuild 1
    sha256 "b7bd8f432922e4b5dba79719692494b57b4dfff1da975053075bb5bcc6c569fe" => :sierra
    sha256 "f48ac053a17ce7a6c4002a5b7fa0a3c480ddfc74086595a4267887d8d3e94dfd" => :el_capitan
    sha256 "42803096ab9d5c97c43cb06a72096fb03664b10b4e0ba014a42af657a9648ec7" => :yosemite
  end

  keg_only "GPG 2.1.x ships an internal dirmngr which it must use"

  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "pth"

  patch :p0 do
    # patch by upstream developer to fix an API incompatibility with libgcrypt >=1.6.0
    # causing immediate segfault in dirmngr. see https://bugs.gnupg.org/gnupg/issue1590
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6965aa5/dirmngr/D186.diff"
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
    system "#{bin}/dirmngr-client", "--help"
    system "#{bin}/dirmngr", "--help"
  end
end
