class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.1.tar.gz"
  sha256 "bdd012c8341267a92345561bd48a4b3f246bf59aab50a14e5648c4b8974f6995"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c4be4f5892ea22c682e1ba1718fb07fefb947940f92bedcf5487cbf64971fe1" => :catalina
    sha256 "9373e186198995ef3988713bd6801737547323c4363d3e77709e02f241c0721b" => :mojave
    sha256 "cb4ffccdbac34210b44f957aef456505db3d6eac2695adaded14ab9a4818bac0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
