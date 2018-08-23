class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/advancemenu-2.9/advancemenu-2.9.tar.gz"
  sha256 "c7599da6ff715eb3ad9f7a55973a9aaac2f26740a4e12daf744cf08963d652c1"

  bottle do
    sha256 "b61eed32b7dbf12a05a73e825df47adab2ee86da445808c0e9b4db5597d2ad23" => :mojave
    sha256 "8c96b4bef369fe6b52d58c9c6d8025a64450fad965af6209c99c7b1edcec58eb" => :high_sierra
    sha256 "875396a5eb77a17ee1cda679fc782d5fa15072a206331d15cb186e52bf4d5369" => :sierra
    sha256 "5e4a2e320562c0d92c3d61049f097d0a7ee054b76bacc8dbf81095c2758bed6a" => :el_capitan
    sha256 "543c8592f5f72c1407fac7e29a9bc298b2d5b15529d669b54338d60209409028" => :yosemite
  end

  depends_on "sdl"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    system bin/"advmenu", "--version"
  end
end
