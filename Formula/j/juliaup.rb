class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.19.10.tar.gz"
  sha256 "04b7fd19423e230108b7f43d9ff07dd292abbe9f1d4bbeffb6ab77f84dd3d572"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ed757698fba62ebac0bfaabbdc5fcbe149b9c3256848ddb610df7943317c39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe0f3893fdb3785af2d210a375174669c3ed8b46fb15211d46c291e5831dd21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "999d43c111cba37b2ae44b1d51b15958911527b63abdc4991c701d95ed43cee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f673a72de9794101aa67e45311f65dfaf824302202b705d1357465738202328e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373657f69c8ebf2d0b362d6020684e1efa8f8d0bb2449ee3b54740fc12d772ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497c2601995620ebb2f6874dd9525ed5913c98c29e63c74372a3d4e2c26f0b50"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
