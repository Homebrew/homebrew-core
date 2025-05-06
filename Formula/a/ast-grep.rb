class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.37.0.tar.gz"
  sha256 "e14b1bae8f81ceb10151e674992e914c39bac026ff89a53db1f3b90bda3c7ca8"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55627b03f2793e676ccbc683b5ee4e98d632c4d81b12f299c12bda1438db0a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5502731b6d2812e493a00057fda8cc37a1084ea4ea8d879519e41058bd552a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b054ccefb691d875027b99ff3872c7e25a246d3c9d50885b705fd7f9d82f8c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95777f3ab60ba5d7c527210ec5dfe26d4debf671963603120a3ab403e984a70"
    sha256 cellar: :any_skip_relocation, ventura:       "4e6251ca7464dd5f0d0f333e0b635e8dcd1c367c26d04523a84903555f1a7503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "412eb6526c2e5733d8d6c423703f282243795ba5174dcb890ffe6be870ecfd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c63217b8bf69634dd52f75cb8cb797e42ca352578634bdce9fe82d437d3b6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
