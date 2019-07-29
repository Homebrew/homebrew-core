class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://www.antisip.com/category/osip-and-exosip-toolkit"
  url "https://download.savannah.gnu.org/releases/exosip/libeXosip2-4.1.0.tar.gz"
  sha256 "3c77713b783f239e3bdda0cc96816a544c41b2c96fa740a20ed322762752969d"
  revision 1

  bottle do
    cellar :any
    sha256 "7b36d0061e7a0681c8187d62b2f6088c0dfd2b2d5d8bc4b56261d129eeca6567" => :mojave
    sha256 "fef377c553a324d70764bb94b4c94a789d6cf584ab69c592baa6c44abc082689" => :high_sierra
    sha256 "bc49bf581921515eff4719d5e0f31c2bffb43137d06affdc6e73a947d80692e0" => :sierra
    sha256 "4ba8b361d2fd38f861c66b470d05bbb21e80ac92236cb8ad9323f1dca6121e2d" => :el_capitan
    sha256 "9fd63688f31b0561749756daa3f426abc58754dc5033f6068dc0d389bde043f3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libosip"
  depends_on "openssl"

  def install
    # Extra linker flags are needed to build this on macOS. See:
    # https://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices "\
                          "-framework Security"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
