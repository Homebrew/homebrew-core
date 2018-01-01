class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 3

  bottle do
    cellar :any
    sha256 "ac3157158ee8a29b8fbf0c9bd785c47e74308c0713a9a618054dd9f3e923c037" => :high_sierra
    sha256 "886b8905d25218094b9a21626a0a7f0b6a20edf9285cdbc0a2e6724e05aac60b" => :sierra
    sha256 "f4e146e63fc161edab98d70386c32550c1343b98a08f102fb0190e6372a24f7a" => :el_capitan
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
