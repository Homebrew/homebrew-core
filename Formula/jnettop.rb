class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "d519f88b031322183f9cfd7303f9d139aecd807037f5d5043997acb2d3324cab" => :catalina
    sha256 "902b1e9e69c982a84e38b09e2f0b15bc84af94028fb32138fd769efffbc6ddbc" => :mojave
    sha256 "944957cbac7c457d3c4ee130e8ac457ebf0f2387c7231fa2b85ead897cc77e8a" => :high_sierra
    sha256 "190334e1019dc9957918164f3fe920607f735edcba3a24296cc634fdd4a70e54" => :sierra
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
