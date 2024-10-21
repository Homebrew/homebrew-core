class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.28.1.tar.gz"
  sha256 "9d9071fe181cf15626cee4244f972a219ba4af1a4327e7c14fe66b9c682e3754"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3403daf4db9e8d3fb66140812cc017e94fdbba4016e822d5595e8f0c03f9d99b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53fa4b0f4b819a7d24187f1cd203522e4805856222a77647746ff3639393f923"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fd834c9799f1db38157c855fc5f7e7d912e0da633d7a8ac2a38e75c5c6992fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb2cbc50b977716465aace3c01563080dc2983a8e2b468f4c93577607ee775e1"
    sha256 cellar: :any_skip_relocation, ventura:       "f713afc385cb4f862b3cf53f5a1aea8be88bbf23ce6fc23bd8655c3b9fa1da7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7399dc075dcbb8c684fd87b5c08d63f5c85d84ace49cbfb81b95eff0da0f7b93"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions", base_name: "sg")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
