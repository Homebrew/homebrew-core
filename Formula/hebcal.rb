class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.9.tar.gz"
  sha256 "dd9bc5ec1838f2f42c0ebcea139e970ddde754087396b6823a3649d04978cdf9"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ab99c32f0453b3881b92540a5f368dd775e0827a1eb8eced0fea88857b61169" => :sierra
    sha256 "875f9f2856f81e957009cc00fd3ee50bd6bae63a7b5a9ee4987a14b0f0b47166" => :el_capitan
    sha256 "cc2129e5bf5c8a6dc45404157b25e2365864d40769a2efa3c4ad9d0acb723698" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
