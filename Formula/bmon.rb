class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  revision 2

  bottle do
    sha256 "cb12924bc48e319aeb50cc16e2ad48370c9d2b298d9a876e87ecf5e2c6a11c73" => :sierra
    sha256 "b55a43411b7791b326c42fa3e71ee4a23a3e8d4e1f94fac4e4a1195f5dcdb641" => :el_capitan
    sha256 "fdca9c39cc4f74004b9bc6b04ba67f50367156f1074406de2b2546ab116c627c" => :yosemite
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
