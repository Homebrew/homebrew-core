class Flake < Formula
  desc "FLAC audio encoder"
  homepage "http://flake-enc.sourceforge.net"
  url "https://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha256 "8dd249888005c2949cb4564f02b6badb34b2a0f408a7ec7ab01e11ceca1b7f19"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2eca0967c020b082f7d7f8c4d15765204ea63aa9332012074c852967a0fee07" => :sierra
    sha256 "e521dae57260b2a71f161f16609530c854ff8ebee4252b0addf3c16b5abc982c" => :el_capitan
    sha256 "af8e2e83dd3c82e8cc26be91ca64e24571b34185d4f8f007725b54d37f38e2b1" => :yosemite
    sha256 "caae2cab90e1e392a93d47b88c5c9a9242c3740ca95e767bca61d9d267f337f9" => :mavericks
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
