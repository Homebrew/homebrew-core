class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "http://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/advancemenu-2.9/advancemenu-2.9.tar.gz"
  sha256 "c7599da6ff715eb3ad9f7a55973a9aaac2f26740a4e12daf744cf08963d652c1"

  bottle do
    sha256 "17b87afd785fefa91eb2fc1aa6e1ac4b96869d8f9921c958bb45e27a0beed1f7" => :sierra
    sha256 "bfa928fd5353506a31320b9563645c42ce951094b628698992c540cd1fc3260c" => :el_capitan
    sha256 "ada2ad9d75ca6887dd4c2e02c8b62fd3281c1146d56f9028bc730721579492ce" => :yosemite
  end

  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    system bin/"advmenu", "--version"
  end
end
