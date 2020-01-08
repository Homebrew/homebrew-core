class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.0.tar.xz"
  sha256 "b97d9b041e5952486cab620b44ab09f6013a478f43b6699ae899b8a4da189cd4"

  bottle do
    cellar :any_skip_relocation
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :catalina
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :mojave
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
