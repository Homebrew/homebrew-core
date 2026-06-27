class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.44.0.tar.gz"
  sha256 "1cc8d5d6a759c6d99c676bcec09fbf1fc72e023804e54480146fd62b300fce95"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b79a97683ce7c156afa52c976e0bd9db14a986bd2d8216a410a99b0fd5431b7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fa45e19b83a95d3efdb5d578010064717633be73d8157bee074f71d7b38dc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c4a0a4d0fddced94e4fca2e68310b499efb471a8775cc542f437d77fe8c5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0f821486fab67b1377997280d4977bd35db278569b67e7d6579800773c691e3"
    sha256 cellar: :any,                 arm64_linux:   "ae9a8b454b1b6aacd8fa0a8eb0ce987b37bae53006a4fbced0e7fc22cf080c3e"
    sha256 cellar: :any,                 x86_64_linux:  "e7c60a3f0f4c220abab9d476089fb39d465c367f3a6ca5d7bdeb34e4a7fe1ff9"
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
