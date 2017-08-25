class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.11.tar.xz"
  sha256 "20d1e7466ca4c83c92e29f9e8dfcc8e5721fdf1337f53157bed97be3b73b32a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3132dff9a5c9270dd72d2ffdfbd8b0e53c2c7bede33bb1c87a9dde2b4ba95abc" => :sierra
    sha256 "8f34165d9e854d0d3cf261775c53191115537c343d65771a458ed827357f05a2" => :el_capitan
    sha256 "8b131b53a8ace806b0b6a3c75be145312377b0f25d92ea578ba07e27809fa852" => :yosemite
    sha256 "d04a14c639c497aea15e39ab5c70fb6753d3a7983528cb8b18a7e309babedbde" => :mavericks
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
