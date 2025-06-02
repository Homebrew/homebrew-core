class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.38.4.tar.gz"
  sha256 "f1c6dc88f676fae236f38cde4f71d160c7161fdc2601ec861c90f16b1c83f1cc"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7160b70212718414574c940ef92294a387ab62b2cea78dada7dc295607873e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f16e9a8d8e75f06753848672d1d8f4983979dec0b5e4aaa2d74cf3b7b849477c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "096e0c7f3d0ec6a52d5192992f9f1a2d7bf9ada98b7b9c384d9820f2df7884b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7239cfc66be6d6fe759d6438e97a5e3adf3f5b7b40d46c918e69735c3c3ccc60"
    sha256 cellar: :any_skip_relocation, ventura:       "96f14dc15fdcc765240b771947c27b42f62b7a8c12fc285b6306636a95c6757c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a60314aac187584b7345be0510c13a0cbe1bfa726f454cbd71e0e8ec78e347a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e91179f8e969e3212e2ba7493ce0e2471ef9439c315a5cb194626ef1e09c5d4"
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
