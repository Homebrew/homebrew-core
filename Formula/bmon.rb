class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  revision 1

  bottle do
    sha256 "579fa840a05774fcd8d688f265b87f612a1a6f21913eee2ce7f35da684c590ae" => :sierra
    sha256 "fdd05ca0f6505ec723a84d4dff9512dd827956e2ba84765dbfecbad2bf3eb20b" => :el_capitan
    sha256 "754511a0b323367dd461a6cea4d1895d42b2c47cd952e6613dcfbe25ac2a2f9f" => :yosemite
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
