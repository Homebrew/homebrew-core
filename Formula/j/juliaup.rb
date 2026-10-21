class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.22.10.tar.gz"
  sha256 "7cd745a53a0e60f96779b4b79dc78644fbe8bb7b9ef228348d4d479669c59420"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "287d18b32bf666d1170739263669a29b2d0c6337aa53647c1a07f0f4dfcd3f25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7efa010e13203f9f5c1123c831b289b39c4582fefa4de0d2bc8ed0c9aa9c58c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d737dbca5bfa6ee64117fe5b4b0c7b3c04dd7ff20ce3b45cdefc340337648a80"
    sha256 cellar: :any,                 arm64_linux:       "9b4ec0c30c9c295f277a3f63451a61b3b2b231d18bce121ca12fef2004f01a88"
    sha256 cellar: :any,                 x86_64_linux:      "19f97cdf468dc065d913faa5de8c50378de23329e5a070e6e0ac9e652b02bcde"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")
    system "cargo", "install", *std_cargo_args(path: "juliaupgui")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
    assert_path_exists bin/"juliaupgui"
  end
end
