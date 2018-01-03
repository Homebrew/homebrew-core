class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/current/onioncat-0.2.2.r578.tar.gz"
  version "0.2.2.r578"
  sha256 "69c677e04987bd438495d575b566c358f449ff138b836925fd406cf6d6a400f5"

  bottle do
    sha256 "81840e780b37af0429f3e8f2797c87d6f45e1784d8480b602902259b3ce54716" => :high_sierra
    sha256 "fa957d2ce8b801d023ad3c3c05999ba8f6afd46cca82e58947139544505f17a8" => :sierra
    sha256 "1adbca52faa26a57fd6e211b24ad2bef538c1e39a78cdff305f1734208000a81" => :el_capitan
    sha256 "7b22a7c2aab941452a5a81907e861043a4a2759691769e7f8d3810a68684bd21" => :yosemite
    sha256 "e60ac97757d5a5a5967f3c16d35f622a0e867d9777521f520b455e258ce92e20" => :mavericks
  end

  depends_on "tor" => [:recommended, :run]

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_f "#{bin}/gcat" # just a symlink that does the same as ocat -I
  end

  test do
    system "#{bin}/ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end
