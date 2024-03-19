class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.19.4.tar.gz"
  sha256 "7e4a1b8b9b1716a0b45ccc05d5e521373a4f0b08ceaa24505735f54b3f6a5596"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "181fbf38a659f98121dd8d88a52664eb4a0ccbf86e95cba8b637208534c8ef3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e15baf8c4a379892a552b53c2ff67b70413478ab2bef1afc029fd7b0d1627d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9351cc0841412a5f299345843b81c7e74ec2b233b0424fdbdc246f4afa93f3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "408dc6a99b63741888b9ba3e8209f11b6178ab58149f1f57f27428b91b962eff"
    sha256 cellar: :any_skip_relocation, ventura:        "65fa7092fe0504bd442a041d98b81b64c6745b00a8d3a5031b7dabe6302160a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e85c5e03fb89fe518c66953a3792038ab7ee1b3a5f6a0ef1022e4aac0efd31d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd463e6cecc2de7d9b216c110e1f1d563cc7554ad99edb8882437f28bedaa785"
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
