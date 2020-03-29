class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"
  revision 1

  bottle do
    sha256 "9e24f64d188be8be36054aad67ead05bffd2f1b5a7c6bef6bc9f98f7ea92fb87" => :catalina
    sha256 "52939d589b5697402b6b5c658ab065651ac1943e8c7c7c9798aca5f76790be00" => :mojave
    sha256 "0a021e6d01b7f7d4ee9d048459ab7367b48da791896b2edeb96e270b196ff202" => :high_sierra
    sha256 "0c9e7fcf39a8fb0c80f867495cf1d6776fbe4aec6010a1986edbca820ed7a6f0" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    # Patch to fix OpenSSL detection with OpenSSL 1.1
    # A similar fix is already committed upstream:
    # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
    inreplace "configure", "SSLeay", "OpenSSL_version_num"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--with-plugins=acro,aim,arcfour,amp,autocycle,blowfish,cavlink,encrypt,fserv," \
                                         "hint,identd,nap,pkga,possum,qbx,qmail",
                          "--with-ssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end
