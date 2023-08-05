class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ccd23b01f22607e4b545b3eb736e13b9dc1adbf7511d86db90dfd1aa22f6b14d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b19001cfa666748190851f57970c58a3c7aff67b41446994e65e639d85fc6c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c5bf34bdddbd3831259d0cfe3d2b8f55e253635f25231d3af42c673c3be66a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f5dc7b8e705954ff6c9ff0ce850c044f8f650d1bc29f4d7a06f25fe9bbeb03c"
    sha256 cellar: :any_skip_relocation, ventura:        "ea8b88946161088ba33e28913892c76d80581eae708d445edac814e7229cc91e"
    sha256 cellar: :any_skip_relocation, monterey:       "a39153918d5dcbc5b64535d7b5834840c457f47a7335162e4ca4d1ac0f0a68a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d60327647689a910739c412a8f9634a60bd6a772c50b9d64f6279e37c997931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68464a8199b799d4af497a751508202a937cf6e15d3fb8bda58f22b6cfee1c6"
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
