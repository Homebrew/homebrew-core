class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/0.2.x/onioncat-0.2.8.tar.gz"
  sha256 "fed003e151458ef2b6964e957266afbbb493e048cb54a46b948edb70df171d62"

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
