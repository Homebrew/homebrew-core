class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.2/turnserver-4.5.1.2.tar.gz"
  sha256 "5f34ded2c2871c74d498712c3fbfce8a418f8ea8e6508adc07cfe5e152881455"

  bottle do
    rebuild 2
    sha256 "72cdf60dab2ee94a4aa139d1bdbbe566a8c30d6e000f85527bf5a1562fe5f09d" => :catalina
    sha256 "3e61ac696114f38c9d6d361b1915b7a1fdae7bedf82c9bcc6bc9ed9a3dfdb986" => :mojave
    sha256 "3896e563b9c95d367303922cb19675f13e574d2bb99bad23cc098975d709a296" => :high_sierra
    sha256 "a39734b4c588d1d311ca1e6851ba7cefb0b0159c5932ad2a5440b0e82025e8f6" => :sierra
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
