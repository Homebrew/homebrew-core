class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.45.3.tar.gz"
  sha256 "0ad252ce2535493e105bd4b2dd6db2829439732d15599825aecb0b02fc9e606f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55648a369c60203c733d1baaaeadd78a5903178ab61742917df70a5b80a59033"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5790bf3727e4c014d457c819b1d53ff7bcd3efa765c74b8939ad90c2e8d7b553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d949edc98046f025389eb34d2dcac423651c8892e2fe89d2952c5210e8c05a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e52c74ea6257a03fea0fde87c68f63960bb9f8dd5b6e5adf98c66a6e68de8cf8"
    sha256 cellar: :any,                 arm64_linux:       "678a9f3478a14ac0e46a99a01a9bd7fbcd6d8166cf75cae5b7b1b42de8ace398"
    sha256 cellar: :any,                 x86_64_linux:      "ea3a5f2db41fc6fa26fb4151535474376158aa75b81cfce4c6b71c6a38474988"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
