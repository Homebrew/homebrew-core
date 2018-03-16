class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/current/onioncat-0.2.2.r578.tar.gz"
  version "0.2.2.r578"
  sha256 "69c677e04987bd438495d575b566c358f449ff138b836925fd406cf6d6a400f5"

  bottle do
    sha256 "1062942ec61923ed49c04afd61ccc9bb56166efe0285fe93b406597d23223fa9" => :high_sierra
    sha256 "539500f5eeed2771a729c9e61196831c3a3796edafcb2c27a38b26ca5674f7a6" => :sierra
    sha256 "98acc41c8dc5fcefbe5a410266a762ddacbe12323e958a8fe6ca753ec51f33fe" => :el_capitan
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
