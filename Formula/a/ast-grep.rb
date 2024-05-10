class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.22.0.tar.gz"
  sha256 "65ccbb8da91fd0aa62235f4a8377732be97f544c7044e5a20fbf4518420226e5"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b451dfebadf1e5c826b47c77577e1b1d7fa241e1c4745ffaaa3144cb2c56b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c6c3870def008f004e99cc75f587b42238cda0087d7070b83cbbc9bd0b12e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35e295574b038c974d58085fefe8e1faef607c7bb1c2d2041e860dfa47f2737"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf62b98fb826166a4c6eef382f3f644c55995d782bd8aaf7aa14b7346ddeacfa"
    sha256 cellar: :any_skip_relocation, ventura:        "fe73c084a5d62ba479bb65d83e59494deafe0af71010fbec28fd238aa40ffb7c"
    sha256 cellar: :any_skip_relocation, monterey:       "0c8b61eaf4c5388d50c98ef206f6efe465ffff357e6a0aef7195af370b82a8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49dfb626454c26ec6380b9e12b3ccdc15ba04c8c7c6cf8348abc320cb0057eb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
