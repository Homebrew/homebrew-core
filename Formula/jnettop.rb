class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  revision 2

  bottle do
    cellar :any
    sha256 "6eb9456614d3079057d6d5964735b89a53401183d53075b79733872f24368683" => :mojave
    sha256 "be86a7a7c8aab464c991770e0eeb3cfda793543709527f872467a83dab06efdf" => :high_sierra
    sha256 "8b1d0bf0ad20377e7b6760a033c1c215e36ea8a4e2bfd89f785a5b7079ad9f9a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/jnettop", "-h"
  end
end
