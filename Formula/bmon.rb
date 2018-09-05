class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  revision 2

  bottle do
    sha256 "d6ab26f7e09d506f05c836413bd2cad39912b97a4111dd4c5acbb22b7d88314a" => :mojave
    sha256 "0e42dc7797916ba3b70729662c78a26fbc0e991c6568143888cded4595dbbf41" => :high_sierra
    sha256 "2af9641dcfa37efcd37eb520b8ed1d2e82c12e23409ad074356959220f1b0a78" => :sierra
    sha256 "dd09a67017c5ba3fffbe8ea14f79157126b069c89c3a452e42462fc65d222572" => :el_capitan
    sha256 "9363be186d292bd7f2c7407713e1202efde1ca5aac6e4bddafc35a46e8989e3c" => :yosemite
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
