class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.44.1.tar.gz"
  sha256 "a5a1eea64346853f5c911982f332f3e1fb670f18483d805d33686086dcce510f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fc99ed5854cfa90b9c45d375ba2ad232292674a9ab75e082bcbe7fc08718bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01fd8d4e63a10a498a9b703e95e0a7a432090fb0dc2b6882fe20ad7dff854efe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b5bb272241584fe4f08b80ae35b1ba1848c5d37d75b89933bc1be4e90e6051"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff8f52764d27916ed18651f5340490bed6f47581e7a4f3ac3fea5de8ce66468"
    sha256 cellar: :any,                 arm64_linux:   "029d017d0b517ca47aaab548f1ef4c75d7cd3ca953ff1d00329acf82b83fbefc"
    sha256 cellar: :any,                 x86_64_linux:  "1c0d82842c173177ca37b6348c4ce711acc76110676fd6941dc9a2c8e64d4ceb"
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
