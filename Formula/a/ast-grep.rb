class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.12.1.tar.gz"
  sha256 "531a0d25ea7e287a9e018aa237ed6f69f24eb6865f9b920f3bdfb0d85c3ce4bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189ffe668aa09ab6015888e02906a696735646b24882e6979c07629b9808998d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e0487bbd5d34e696030618ca8a12668691c6b1c23b2f2d35250d849c66e9d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4693d203fd94ab0d849dedf5113c5f44b77d8eac9079f836e5da6f22189b791f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7416457778c1c6532b7686a7ac5b78645fdaee1e785273fefed56b140de2b325"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f766d429b60bf6f8cec76e8b4aae969ca06b78270038a87eb90161a7e4c7f8"
    sha256 cellar: :any_skip_relocation, ventura:        "56cb23efc531c58b6fc1d9669045355df76f0ae44acbf8ecab132224a0cc112f"
    sha256 cellar: :any_skip_relocation, monterey:       "9851275ec540c2fcc7d06eff782306fa122c22c0e421309320e3c82ad38c7a49"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb85a216160e4a60e9d0a8f4c1774fd4bf434bbf23bb091f1fed55f60590cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "702375d69a22fe91ebf131e8ee405c970fb540af77da046b2baaf10a342df46a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end
