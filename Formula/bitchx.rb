class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

  bottle do
    rebuild 1
    sha256 "a54b24df15570ceb3e8e62717c98941b0b0b4e4066c191053029abfaa6f0b39c" => :mojave
    sha256 "799186d1028a2ea88f40cc0e6653658202c70d721b73ca2f1f673258d3388d63" => :high_sierra
    sha256 "c97728febe95f8ce82a9bef839d811ba751ce323ae6005bac51b7b123cd47790" => :sierra
  end

  depends_on "openssl" # OpenSSL 1.1 support in next version (1.2.2)

  def install
    plugins = %w[acro aim arcfour amp autocycle blowfish cavlink encrypt
                 fserv hint identd nap pkga possum qbx qmail]
    args = %W[
      --prefix=#{prefix}
      --with-ssl
      --with-plugins=#{plugins * ","}
      --enable-ipv6
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    On case-sensitive filesytems, it is necessary to run `BitchX` not `bitchx`.
    For best visual appearance, your terminal emulator may need:
    * Character encoding set to Western (ISO Latin 1).
      (or a similar, compatible encoding)
    * A font capable of extended ASCII characters:
      See: https://www.google.com/search?q=perfect+dos+vga+437
  EOS
  end

  test do
    system bin/"BitchX", "-v"
  end
end
