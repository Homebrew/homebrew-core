class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.0.1.tar.gz"
  sha256 "b6b58273eb8a0831b9d241bd5efe8d3aee495528221f4ae82ac187b37a0101a2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d930263379be0a4b38c1813f3b7a058629c2f3a46ec6ce57aea1c199483430c"
    sha256 cellar: :any_skip_relocation, big_sur:       "948f53eefeb6e2c9827faab44cde97a01378c35549021361d99ed2d7b7319c6f"
    sha256 cellar: :any_skip_relocation, catalina:      "be60aea7ecbb61c23b4139c06037b65e29a6fd250f52aa5b02eb327ac870bbdd"
    sha256 cellar: :any_skip_relocation, mojave:        "17fdc6ce9b5c1d4e4003b6aeb152219741bec3052997f981bc565e1236e00c5c"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
