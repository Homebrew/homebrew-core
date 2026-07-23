class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.45.0.tar.gz"
  sha256 "996e9d879f095d3ccef55754d3a32d61e1ae03cfaecdcff5e247bfa5b649b27a"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62cde295abd4e37220c62ef1ffd1dfb5cbb78430eb01ab7c07ba31e19b15d7b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac6bc1b25e4a71c1f034d28725cd9467c761cb1f093f229d8577784557eaddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2642a8ca7dff37f5b5a477cdb41c1ab58af69e352b90795ecd68f8094027152a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d72b85fa053ff8eba70b380ed6c7ae77286914389ac89aefb7a580c4c2cbe4b"
    sha256 cellar: :any,                 arm64_linux:   "1699342facc898f48b8c4483e9d76ff040517e8b1d642a1d7a04e7b648575aad"
    sha256 cellar: :any,                 x86_64_linux:  "750ab538912701413bd34a1cb4f6867d749420c7d0154d52a235adf8feddb625"
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
