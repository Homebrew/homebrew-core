class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"
  revision 1

  bottle do
    rebuild 1
    sha256 "a54b24df15570ceb3e8e62717c98941b0b0b4e4066c191053029abfaa6f0b39c" => :mojave
    sha256 "799186d1028a2ea88f40cc0e6653658202c70d721b73ca2f1f673258d3388d63" => :high_sierra
    sha256 "c97728febe95f8ce82a9bef839d811ba751ce323ae6005bac51b7b123cd47790" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    # Patch to fix OpenSSL detection with OpenSSL 1.1
    # A similar fix is already committed upstream:
    # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
    inreplace "configure", "SSLeay", "OpenSSL_version_num"

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-ipv6
      --with-plugins=acro,aim,arcfour,amp,autocycle,blowfish,cavlink,encrypt,fserv,hint,identd,nap,pkga,possum,qbx,qmail
      --with-ssl
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end
