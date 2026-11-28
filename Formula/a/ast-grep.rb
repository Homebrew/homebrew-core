class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.3.tar.gz"
  sha256 "2a40a15fe439f24e24a88d2dd0bd3433a47bbd5032d43f6a4aa2522e397e8def"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    manifest_sha256 "ab16fe80d5dde377f3a1fb683794318e1cbe150460aeb05e5c2e9ab500a05a87"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54df9855efe886f9413974a21413669fc006487a985f8dc2301b70eed1c2fe04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98f9375de25ecb18d58249869fe1e2bee11899a214e1f79637c0e1d376c0bf39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d1b12f637e6f2bd04c8783253d9e30a702236e7ef40d6d837c6ff95dd60932b"
    sha256 cellar: :any,                 arm64_linux:       "0efc858fa0b75b6cf561c9d6cece3ce19c166494af541478708e403d0861a97a"
    sha256 cellar: :any,                 x86_64_linux:      "cb5ce2f66180721df6e309039316303b9a6b790018fa792b4e500d8f40be6f58"
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
