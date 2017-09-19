class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.11.tar.xz"
  sha256 "20d1e7466ca4c83c92e29f9e8dfcc8e5721fdf1337f53157bed97be3b73b32a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e8e813984958eb171d5a7aca5c4af2f284c75098f72d0478af424a03286506b" => :high_sierra
    sha256 "c86ca9a93c9833d42971c03204b8a655b04e2444ffbc3f90126e7ba0c7411bd1" => :sierra
    sha256 "c86ca9a93c9833d42971c03204b8a655b04e2444ffbc3f90126e7ba0c7411bd1" => :el_capitan
    sha256 "c86ca9a93c9833d42971c03204b8a655b04e2444ffbc3f90126e7ba0c7411bd1" => :yosemite
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
