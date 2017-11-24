class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 2

  bottle do
    cellar :any
    sha256 "b1eeef97edb1fb137bf6fe4141c738e0f8a20ca78eb8b73c4e15c9550a4a5a96" => :high_sierra
    sha256 "472626b30f5859a0e8526e49492f04e3886b1c5acda2605ac4d3e19015085d2b" => :sierra
    sha256 "4bcb17aa31229692c090622fb31019cee6c6cf2f4936c2ff76e6a957d260449f" => :el_capitan
    sha256 "31bac3b617b0a046126e6f0cd905e4acf95aa5c3910d3594472bd537c9686b1a" => :yosemite
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
