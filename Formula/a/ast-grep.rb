class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.33.1.tar.gz"
  sha256 "6926e14481e5a34f3e4bacc24459f894b0214fa460f60027be5a52dd74ddf508"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e67d51937bb2ffe3940a550db5cfe5776eca8acf664112acddac43718fdcb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10cc6d51c4dbc422beaf9425d8ff781d0deff0aacb9892b7ddc9f50b2e061c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ede5abac9a1d83caa8e4e7ded436d2e77ce7166167d42f314f6cb21d618888c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f03b6ac5885ff6090d606dab825b59d7f08ff5a135cbd6103fc4051564bcc45"
    sha256 cellar: :any_skip_relocation, ventura:       "fa5cac492657d092c674f0d6cb6286798dd09fa6986d51a4f76fa21404877d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7287a35df7324d1c19f4558c2c9f45bf44adeb2ea8b10f093818214abb4e96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
