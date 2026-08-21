class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.45.1.tar.gz"
  sha256 "a3cf5afc5a7302c79df56c2d52762a70e8290ce86291050e3febe90abd388d6c"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335bb9338786893cfae6db0e4c5c4f0a9db0403cbe11f0cf4789a569791f41c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b595fc26bac119e5fab1e33f33289cb180c931af58b2dacb1d2a5fc158a7f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7123b451165c47ab2f53b5ae855a56221e95cd5955a95eecae3518c5f9d2eb92"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ffd88322573f11e768b324bf07e6674715f3cb786c2bbde843e963e52849be"
    sha256 cellar: :any,                 arm64_linux:   "6a0ed6e4aeed382cc5ce895deb6313ecf676036f0b94d72bb65fe69dc2737be7"
    sha256 cellar: :any,                 x86_64_linux:  "8048860a5ec200cf274fb8af21eb05bafd3c40fbd62e366aa0fb4455ce5b4d53"
  end

  depends_on "rust" => :build

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
