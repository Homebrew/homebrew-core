class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.27.3.tar.gz"
  sha256 "7de51d65943a2a59bff675555bf8584bef7b898e62605987c6676a24cba93320"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7954dc98701b21552e10f697deb58bd825110f0635c0157bb26f0d481b1eedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09441396afa8035b5e59ff8604c7f6807d8a5c9a4274720b5db023b0f85a38e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1baf045674bb4aa0fe5b1d1af2be34734023c4b9444234a46fcf345eae89e773"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae16dd561698ca46409a53337b409489b65d403dbbaaca4d42c20f584359ab62"
    sha256 cellar: :any_skip_relocation, ventura:       "e83ceb4c29a81743496b0a12f2c9eeb7d9d25c27fd2b1858f901d84269a292fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfe9237ceeb854747275e99eb3049062ec421ca570870ecfc52727435a1a709"
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
