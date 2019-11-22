class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.35.0/esniper-2-35-0.tgz"
  version "2.35.0"
  sha256 "a93d4533e31640554f2e430ac76b43e73a50ed6d721511066020712ac8923c12"

  bottle do
    cellar :any_skip_relocation
    sha256 "609f0b7d7331c4e61d274a83cbfc7157394d905a5840c6df7547140b5b0a44da" => :catalina
    sha256 "09be416cfab61002deed7613c367ccfa56c53cbe4e7ec6e1bf07df769313a7dc" => :mojave
    sha256 "24cb48a074e7e13cdaa2f0c990ea184352cd06f572134640fa99a42d699939ff" => :high_sierra
    sha256 "da1e8988910e0ab959e3750a31796d406b63e4c91ea05cd3f19415adc082f59f" => :sierra
    sha256 "d269d258369cfb214baa129ade61616121341c0129d820e9c77dec6b841ce0e1" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
