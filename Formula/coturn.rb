class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.7/turnserver-4.5.0.7.tar.gz"
  sha256 "86248c541a1184eb388c54d4178cffbf16ef53504fbb60106e575194f078b221"

  bottle do
    sha256 "4223eac517f9c5499d2fa27b2d8c42d2e8f6e6c27e3fabffb4e671a5f90196bb" => :high_sierra
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
