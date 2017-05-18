class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.4.tar.bz2"
  sha256 "8915141836a3169a502d65c1ebd785fcc6d406cae5ee84474272ebf2fa96f1f2"

  bottle do
    cellar :any
    sha256 "1dd86e0fb9379ec101c85acb6689c43f2df49117ee9494060acb503d24516d09" => :sierra
    sha256 "c29fe0821faba0cc0b22738a7588d536c263ed0fd8b10ccd151bc0a69f05519f" => :el_capitan
    sha256 "2c067eec2b441b5edc2119432f02e9e8dde51cc7ed33515357b6c70e1bf7722b" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
