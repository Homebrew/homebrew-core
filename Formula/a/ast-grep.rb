class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.11.1.tar.gz"
  sha256 "0d4ed9fce276ad64057893ae01d4af7a8709acc8609309fa6b78cd750d9ffc81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e8cba8ddf6d47f0a06e7b3f4f385112743a9ffa1b9690ae762a5ffae2565e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fca1bfebccc227f3556ff15476f32a2a3bcab7ae32c5d8fbded455b9bf292d5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32d7ca1661bc2d30f84f8e5d2d7bf56a79ea419fa3c44a13f8f08cffc815d470"
    sha256 cellar: :any_skip_relocation, ventura:        "14893b400b2d167f96e13f160a8508711fb5a454e16d29760ee0bd4055074f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "fe60fc836e3a362ec1aeddb485c752e9118265f6e37bbba233c0206ec55e8b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b428bf75ccf94675760e2f9c7c6a601f8e25b7d853adff567a1c00c64fc1dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e5946708e0b2c91b3293fa74b3235106dcea52708cc06245f5fb66613f30e4"
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
