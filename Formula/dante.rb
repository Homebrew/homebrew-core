class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.2.tar.gz"
  sha256 "4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "ca6ec30ebd1e59b644b7228bcdc0b67b5885d392d77a0c0991a42c06e9533455"
    sha256 cellar: :any, big_sur:       "1919afe3e3606a31469a0a5443a918d5e8463ce737dbcb3291a5771ae0797016"
    sha256 cellar: :any, catalina:      "d04be77c7a05eb220c08e161cc017b1029c25fc3aae0a9991d20d3493a57845c"
    sha256 cellar: :any, mojave:        "26eb48c9eda005d8486f2dddee23420047a326f82638b71c5aa2f7d28f3ce402"
    sha256 cellar: :any, high_sierra:   "6a234a72eb6a8bc9439a9a45129ca2214151dee7b63c1ab76c7b5831bda8d1ea"
    sha256 cellar: :any, sierra:        "5d4fb552b729372afc0b5450af162d9b49984c64e28d7f1825fd879b4cf3bdf7"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          # Enabling dependency tracking disables universal
                          # build, avoiding a build error on Mojave
                          "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
