class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.7/turnserver-4.5.0.7.tar.gz"
  sha256 "86248c541a1184eb388c54d4178cffbf16ef53504fbb60106e575194f078b221"

  bottle do
    sha256 "33e924b07dcc67b74ab28fb262f5bfe09e526ca2fb17cf9c195962b167e654af" => :mojave
    sha256 "275b217ccdf59713da3850782079387a78f24d0c1a35a9b23e67e01695f9e340" => :high_sierra
    sha256 "079bdbb8abae75b20318710269f57b16c53088bae5c55d15073e6199f0526008" => :sierra
    sha256 "2aef5b4ca2b27abfefaa9b90fec75328839f7e02b601d83d9b3afe984240c49f" => :el_capitan
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
