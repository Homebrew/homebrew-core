class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.8.tar.gz"
  sha256 "7d3a99fae193b717ddbbe2dc0e22c9ea582417b02fc02adfed84c8034102a179"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5713c2aed9abc3e052b96cd7941293048dea3b07dbb44ecacaf5299bb0b10aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4130d5a940accee2d420a783a9674a7eb7e5cdf4138eac41893b091bb73e1fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5c84ba14209470848c27349c79ce56a7a3fbfe6cafb34f1b6436dc6bd4efe47"
    sha256 cellar: :any_skip_relocation, sonoma:        "879561885e8ad5cf2172117edbc5ac567e5f6c79791c366b758d34767cb0bd95"
    sha256 cellar: :any,                 arm64_linux:   "ce85d85bdc9625e38ff2f2b4e18ab8c943fb3c2bd111c26191451228582b10cb"
    sha256 cellar: :any,                 x86_64_linux:  "63ca6d229280553b7c5e46926d3d3fc5b642196f028a86a99ebaf70040f040e4"
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
