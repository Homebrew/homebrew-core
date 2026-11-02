class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.1.tar.gz"
  sha256 "a9cb3f5cac1c0d22df189117df8d78fa3d7e9fdcd83fb5b6ab1f0b66c8835a55"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31ba16e32d8b4bacf937b303c559d3c8b946ed2d6430e865786d9d174177e6c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47aa87982b51b7a9048bec48e4c019a4fa698af5a03d7146d8de73fb3768af19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00c63154bf8dc02af8ca993093619565a82182a2f205af34bf4ff3e621717a16"
    sha256 cellar: :any,                 arm64_linux:       "acc4fa819eceae52f49fee4167fa141b8317e3e76af436cbc7e0dbb617f4a894"
    sha256 cellar: :any,                 x86_64_linux:      "9b18884f2ceea7c96e4d7426954f4d4e354ca03c4276e71aa873618e08339a25"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
