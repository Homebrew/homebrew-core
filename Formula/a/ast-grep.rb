class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.2.tar.gz"
  sha256 "757f89f99b2559af7314b460c8397fda0221ad6b958cf6439358b83ef0364ada"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80bba946d2f88becd715943817d0960066216451ce04c26ad445386b86e5a4fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0804adbe873a2794bb15e1dbb1cf6214e145cfaa6b8ad48bfe988f2bb6e0c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dee575394398cf69509a03e590a09a54301e314b36241fbedacd5e2de80cadf4"
    sha256 cellar: :any,                 arm64_linux:       "061e72483319f9832f37823ac7b5a7b168eddd78b59a593b9bae302fb3ebc292"
    sha256 cellar: :any,                 x86_64_linux:      "12483c1d0fb3bbb87d93bcbb4b578aeabfbc1e8c6dcbc1f66863911355a9da99"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
