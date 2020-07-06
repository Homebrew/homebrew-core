class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/0.2.x/onioncat-0.2.8.tar.gz"
  sha256 "fed003e151458ef2b6964e957266afbbb493e048cb54a46b948edb70df171d62"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ef31c45ecf525bfc963069d8020dfd8d63ccad9b779ad1efa4ea4c6ae8832db" => :catalina
    sha256 "f69495ac60b021b3d84b8abd2f74152d93bba7bbb59a5c0a28f0edcaf7149c0c" => :mojave
    sha256 "62bfd76828320dd38f8081086ebdfed307f112f88019a348c39d43b53882893d" => :high_sierra
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
