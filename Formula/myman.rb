class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "https://myman.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  head ":pserver:anonymous:@myman.cvs.sourceforge.net:/cvsroot/myman", :using => :cvs

  bottle do
    rebuild 1
    sha256 "ba8e3fdadba971f9763e96f531c704d030d3ff6f6c6557d43cac92e01aa163a7" => :sierra
    sha256 "8ffde037fde62bf63f22852046222de94c028feaaf3da00a710e91a49828d400" => :el_capitan
    sha256 "65ef05e9d57905b960792f00ca8195e6c9aeae14b053a79384dbf2158b99e1de" => :yosemite
  end

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "groff" => :build

  def install
    ENV["RMDIR"] = "grmdir"
    ENV["SED"] = "gsed"
    ENV["INSTALL"] = "ginstall"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/myman", "-k"
  end
end
