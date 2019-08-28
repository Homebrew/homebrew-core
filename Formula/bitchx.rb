class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

  bottle do
    sha256 "e247158fcd923d2d4737671a1d5c3f71481f280074361e720f0bae4faaa8d19a" => :mojave
    sha256 "42821be4a7f1514e6559a7104ac6c30d12633399b38f64581138940254352bd0" => :high_sierra
    sha256 "6ebed76309cfd3d35bcd700515e8fb97610102fbfa072a62e5769032c5e2dbe4" => :sierra
    sha256 "c76cb88aaa53b51248620ce021b6ea771adc77716b04291dcbaa36d98021b20b" => :el_capitan
    sha256 "ebb3d7dd9342843c47964d4c545e76136aeb4e200f9495cd2767d0e31fc37181" => :yosemite
    sha256 "494fd5d6084f70158e82d49a067439770935d5aeeb6223d1c229a27e6f7f9e8f" => :mavericks
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
