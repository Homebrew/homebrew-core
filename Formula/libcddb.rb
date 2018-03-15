class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 3

  bottle do
    cellar :any
    sha256 "94d7f528e8a973b10e501b390e5bd1c7173b2b63cbcaec311975ab70fba5dc36" => :high_sierra
    sha256 "05158c1d03538f29cb8f4bd932925efaceba92eb87a748538deb25977b5f3238" => :sierra
    sha256 "bf7769869336f10b416971cef25252e3afd93a791c4d96ce5d4e134f449a8991" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    if MacOS.version == :yosemite && MacOS::Xcode.installed? && MacOS::Xcode.version >= "7.0"
      ENV.delete("SDKROOT")
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
