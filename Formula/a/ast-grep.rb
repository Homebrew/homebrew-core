class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.16.0.tar.gz"
  sha256 "523f68b73c534a9881945f30a77b3be2183164d18f41d4b54adf610b925b5f62"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d83ae47f1eb7c4e86a2d0d24ba70b199afb7c4d5632f4e41496b22b5e564ea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a545124e1c1c04c65cdca7eeed6d7e37dda4e93980219e3b4c9ff15046adc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8875203cf8a1d1d8758efcbdf24d91b263d3c5dd08ee32850ddfb74bccece6"
    sha256 cellar: :any_skip_relocation, sonoma:         "93ade6a4f6492e4e062ff720574cbe4899d1e85283396f5132437d3014e6869a"
    sha256 cellar: :any_skip_relocation, ventura:        "93a7402d2d4a8aed848e5f022a9806f3e87e9bef25b6df57eb5833c14aa6ceae"
    sha256 cellar: :any_skip_relocation, monterey:       "cab6f56ab77368d4cb46e604919fe3b14c9026898b1e548fe9634bc2d0a42d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf3760da11e8937a4148c320163aca36e4b058337cd53e79753148cd61854a6"
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
