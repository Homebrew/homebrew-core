class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "99fefa2a1e870d5071af4a251bfe0279fd42a18aaf1674019bc640f1ff345ed3"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2ec5de802d288ed7f866126f369bef3109e9c94bb769c8423e3644203ab0e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c13b008ef59cde95d5939c0ebc647d317c46694f5ad3ebed45ba22107f8b5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba36d2979f8b8b7b94404a7d4b358ff1a7a7e463aae03b63694c14a5aac182a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c8bdec8a68af287cb2031ab5cfe4fd05e111c1a919b6b5cb423cffa78a91b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fbcc7c785e9de771312ed1e151daa65d67b762c03460e087db6e08b1cb958a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94a1ad58a19c67094bf22cf082de7fde81a7e9c60c17d08f2dc69bf5fffa6f6"
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
