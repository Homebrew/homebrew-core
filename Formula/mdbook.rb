class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.10.tar.gz"
  sha256 "ecd1d4cee5b5fa7781799f83010e2074262929a22e37d308061b54ffa7e42f69"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "554151ca6d1771fbbb6dc2dad3d27dfa40629680ad6511690c90596445800ba1"
    sha256 cellar: :any_skip_relocation, big_sur:       "76903aca2380189e21bfd257a8ec8b130e069fb03cd4415d46ef1af6a711ce2d"
    sha256 cellar: :any_skip_relocation, catalina:      "59e2e920e318782714f1841abb0375f8f17e151f576db14fa0e9041ac14e26cf"
    sha256 cellar: :any_skip_relocation, mojave:        "2f358d7915c4c9c6131e63debcaeabe3e77bfeedf4ecc41dd01c6db5f0229e2a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
