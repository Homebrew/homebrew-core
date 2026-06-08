class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.43.0.tar.gz"
  sha256 "1fb6c32a5ae96254d54df7c4358f664e5c6bebdd7754c8b9a3a7db079fe4d525"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3b8f1e80564bbad94c72b307999bbbf876462f06004d0b31b98ef8c0977bc0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7639de28b4becddd39f68d15f10b0dea2355d362ecfe295ca7ae5d4f293187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d302e0f236feed599b2a8bf7e32a97d33bfb6823a4dc5076f7b6f5861337dc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa8c9c82228c329563b194deafeb024e5a4b320105fa95ab519f778f4032758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222f7b9deb03c3b45fcac87f830841260a60d676aaa70066ba8a5c35f55f5c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197984baf50547ba6248d942393b52eef14f42893117f8453e3a85de33ccc750"
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
