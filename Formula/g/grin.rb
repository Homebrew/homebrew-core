class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "2b4723c3ab0e81a4b385e2d85ccc3f82b1046b21c2fed3c76aec1a378a5d8e25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5c0e92ab41231241e55db71d1254d3d6026d1a093dc445754ea618105274b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26758565cff7df8e17a31c739aebe537e3aad42977bbb08f3df80f20bce02493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9177df554ba2583c35656d4fdae783c7d447b0bc94eda0a5a04123460cf7a51d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f615ccb1d035aef3f74d15476160441a9f49da8e203e27f843bda89fa1564779"
    sha256 cellar: :any_skip_relocation, ventura:        "c601bec78b350550b5910aaf3e75235c44b78bf139cd834426ade82ad2992cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "5c4817d9563a2350a7ffffda87c70a9b87acd5357bad27bee8b106f4aa966579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3fde9083c4d4a3d65c99e9b4bc0cc04371dcbe2eb5ba7e4e75b91a2010778b6"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
