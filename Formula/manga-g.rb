class MangaG < Formula
  desc "check some mangos"
  homepage "https://manga-g.pages.dev"
  url "https://github.com/manga-g/manga-g/archive/refs/tags/v0.1.0alpha.tar.gz"
  sha256 "cebb3fa0b08f10dc96d3de10030717fc98f6a196be610eba1bfceb8069555eeb"
  license "MIT"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
  end

  test do
    system "false"
  end
end
