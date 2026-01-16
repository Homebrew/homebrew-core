class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.5.tar.gz"
  sha256 "59188d6e1d847cd02fb77e65a984fc7add2cbd564d4809fd6bd67f5fdeecb6b3"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff13bf6c54ad428b83a5b0680d4b98f5d4acf05a94a3f2733aebbb1d70b438fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ed45c8d1beb92debf2af3acd94b069eda6051d226adbbf413f2bc6ce4ca874b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcc282296ae62eaf074867d44a1f1e8880bb9040c883fd27e5fc8cf5bb17324a"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c3cfb55576eb2f6de55222a591fd55a52c286e75311a2b3745eed8c469f95f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6756ebb2203734f80abda02566277868f51d1c55e2388ad976b83c22f1eb4494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9587cb7c5046509e6d1ef20e26e5ffb0eaa3bc4cdfcecb2a6b08a3999c91345a"
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
