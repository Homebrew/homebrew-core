class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  sha256 "f6c2883cebec5608692d8730843d87f237c0964d923bbe7aa89c05f20558ad4f"

  bottle do
    cellar :any
    sha256 "0dad12f817ca2c61cb4f1426698901d3adb6c23ae443a870921d515c74a67f76" => :el_capitan
    sha256 "123d144d93b05838ce214ce58d8f57c0f0c6a78369d8dcc4340243fcc52ccb7b" => :yosemite
    sha256 "f9132545434af2ab14457b574233aedabe15d0b843ca4a554f7f5e5bbb011af3" => :mavericks
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
