class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.5.tar.gz"
  sha256 "d0498fe9173ce6a4481db5808a39761d073cb2d7e2908bbcb5015d2b41eea157"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5c5c55a4b58065ace23fed0830dbf46350a4e7e6e350861abcc55d2bfa2c398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacaec0844e60d8c59f8b3677d263a433afe96d012d8e62d5c32f883ec5363d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9015f727146342acdc9416a6342077258f8d0f2b940be2f32bc252be4d0725e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c6521f6c377caa0c077eec66cace8066f4a14b6b77763af6b710fb6ed1913d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "16f0306ac0b910f66e92204e9cdf36a165cbf61b89fa76dd81ea33cb1824958e"
    sha256 cellar: :any_skip_relocation, ventura:       "a9e4daa9760d8c100ae6149a1415f74a04e7bdbf6ee2a447750622162e97b896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e49dc56bb80afc671a42dad3a8d8cd6cd99fe383ad87ec52f0ce9961f16fcc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3c685bab647b10213c1f35cde3217535c0de266c7e030fed65633d0698c32b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
