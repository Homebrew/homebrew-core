class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.7.0.tar.gz"
  sha256 "2076b479638d4ae5c1d1009c915527213175e6ae1b18f95d296092cbda0e7cc2"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03350686a7d15fc9a6b183a6d00bde0d870f525d86f8974f652f71936c31d09e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaaeccf00d6cb47df1450226435c8aac79a3382ab8e15359a564a9b8caaa2d1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e969e57c6da559b1e4e980718c2cdec6e304afa125de78df4c5b8358adc52a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "56e363ad822621940bd16b849fd34193c726b152fb6d1ff2a19fa3212ec35fa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ad17b269b57c784a65379c15f7de65b4bed65e31f08bbfbdcd20db08407ac72"
    sha256 cellar: :any_skip_relocation, catalina:       "5738d62c0959a59720506d5c81a1287d1db6341760d3bbe8fd5eb9544504de09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03fe087c83f3d29d4df34ba8fe71be011344107973db6673271a282e9eb1017f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
