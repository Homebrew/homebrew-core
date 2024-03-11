class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.19.4.tar.gz"
  sha256 "7e4a1b8b9b1716a0b45ccc05d5e521373a4f0b08ceaa24505735f54b3f6a5596"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "921ac273249184d4b413a514c4942139270fbf8923d0710ce0ba8e014b2ba9ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "673c33dcbd9fbb712ff2bf6511f10972bdd0e2900bb62efc5b3965ea5c1e64a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50d5feb9ecadd17c2b8a7c503efe5990086b650f32ce675d006932b474dbecd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "96c6000b93e80e858260bc8e67a0f74773a31c6e2a4519327c08ffcdce286295"
    sha256 cellar: :any_skip_relocation, ventura:        "a31bff63bcbef6cb08c4d835a94db6ab9870599cfe0dd4293e5dce28bfc44cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "d0c26c8ebcdd3d343e91d9b5dec5b9772a727b8823f9d9a58d1a5c91821fc6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c115c150663d0ed8bb6e4b8c6a627f3ed335cb3b4b29047f2b6264ebeba04408"
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
