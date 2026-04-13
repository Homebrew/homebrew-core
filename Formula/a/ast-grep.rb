class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.42.1.tar.gz"
  sha256 "3e5f6825e4ebb87d0bcd8375c4f9f0d8c158b89e96b1140035b88dc152f92999"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a785a3e59cac9b5f767c023cc682667fad5fed89fa050a0eca605328a2de7cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ac6bef2f0750341ef63880519b362310ee81c09178ef621c52a91e8d7d398c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae82c58124f2a0eddf13ae05fe323f505315446dd524bfeb6e3b1d39e6735b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d871e59d7c899448c8b8a4152a3dd8fe0b77e68b9f10e5a6945a1f35c25f54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95561b61d5bfa0bb3bd440ba4227a7c3dffbda55f684fae8e08d3a374a5063b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e029d66527fc8be5765629b9f05a7a886c42439b15009cc59eaa318fb89004"
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
