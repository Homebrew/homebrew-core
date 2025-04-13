class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6967c065b32345db89b5e07e638d84276ef887f17d3d1a1c930df9a6e81e93ac"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffccca26544854e2dc0f6aa6d9f333dc1ac4a453a88e8906a308ec8260431d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049a5356450e17089be3bfc2c36393c13067eaf71067ef3f84a8d2e3b9e1849e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "631070f45336793a4a66791f4052357f727c48fb2a9be7fe34604d484890674e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6183c0363b05838b46c4e25efd6b6cf823d1a24fb3dd12a78acb107868d6e41b"
    sha256 cellar: :any_skip_relocation, ventura:       "e01501b42bddf03c906b984b58eb9083135dcb1b8f2e97c03cc9f6c43ec7a67b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbdbc43a88ac5e4f47f4dbd9182716a3a0f732bdde43c0fbd1737f9624c28319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60743558ac1b9c514092fd8c79a1ec3603d4720d0e5551dceb9bf506d62a35e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
