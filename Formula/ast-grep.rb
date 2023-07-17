class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.9.1.tar.gz"
  sha256 "23d0a29846ba19ee06b51b31acba26d2693e6ee7b08d55814464df1fcc0b2dc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78fd9528e98f768da2fa1c25dbbbeceb4bfe194d83645e49998e66ae0478a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736ac1478162d26d323ad034c57318b65a2e1e887095ef982e30c9d138d8a76e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f949c0ca048852c5502be894b6a39880abc4a8150ef88dcaa47071cc11f4b372"
    sha256 cellar: :any_skip_relocation, ventura:        "2f44aa8927d2ea97581d1e048fb693042064f12c952f9b5672f85bb116d20a03"
    sha256 cellar: :any_skip_relocation, monterey:       "a69e08521ffe2fb4b16dc06e729ced11e0352d169f9cd5bd6448ceb663322a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e5002328b659e57ccf3f0b92ff51fa4560d8ba5c53918c625f6e9574dbe2f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca83149f41c7d3764e9e27577d15af135b52b6b1759856e4e64950ff2c1cb052"
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
