class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.6/turnserver-4.5.0.6.tar.gz"
  sha256 "c0ff3224084ff9a9504147a7b87431ee815ebeea0de7c7cb67126859da7e25a6"

  bottle do
    sha256 "1284bbf2a86fd2309901f357cc957de4d21156ab0c5a7c3e4c3e7d7bdaa39beb" => :sierra
    sha256 "dc713646ee013d0794759d1b540e7b2f6b458224b17623974283e27818449364" => :el_capitan
    sha256 "7dd68ad44ea4a7f69030bdf167b28fc854d56331b92d06798cb6dd4347043677" => :yosemite
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
