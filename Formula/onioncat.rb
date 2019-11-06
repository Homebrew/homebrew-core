class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/current/onioncat-0.2.2.r578.tar.gz"
  version "0.2.2.r578"
  sha256 "69c677e04987bd438495d575b566c358f449ff138b836925fd406cf6d6a400f5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8e5072dbf56e675d189d93820e6515b1b2b79f3db41720d148e6b4c4b96f9242" => :catalina
    sha256 "8e8db91685902f795fae00325d15a0599009cfb9aa7441328a86525a432d58cd" => :mojave
    sha256 "cfc80dc5e65d788e2433448a3b48d9705f3f1498b85ea8204de760765d371665" => :high_sierra
  end

  depends_on "tor"

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
