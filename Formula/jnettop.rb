class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/jnettop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "1a077d39b05adcb4ba5a5e777e6ff054ad3b910876ff3d49172057f050e8b39c" => :big_sur
    sha256 "1f1f3c5e26f7fc52b331300926a4aa93e1081b31cc20cb533f9b0791477cc101" => :arm64_big_sur
    sha256 "13d9effd79e9b18faa659af615a7b68c7a940adf5eaee5e30806553e1a237f0f" => :catalina
    sha256 "5b4a91804760ca7e39c76cbd16cd7612ed002d429f8996004e1da49d92839c1a" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    # Work around "-Werror,-Wimplicit-function-declaration" issues with
    # configure scripts on Xcode 12:
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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
