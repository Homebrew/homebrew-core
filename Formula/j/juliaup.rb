class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "e33d53a71cd3c54537af21ffa935f60046a2b6e84708b533d7c5876f5ce5ffe5"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "911246c090445d0465fd1621379533ff1007880f62d1df886bc37c92763150f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "104d37d949b16e17810a6747caf627cf28c9ac0225c7497d172bcab98e297dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7704096f7c7c2c734337dd3700e7c9ac81ca40ae29bb59772a8497903c780cf9"
    sha256 cellar: :any,                 arm64_linux:       "2e1b82b5ff1430f53a3ff450d6ed696d79f43f25d8167c9df5e9c82adc56f2c8"
    sha256 cellar: :any,                 x86_64_linux:      "c3818ba414715943dc273291f68d3c982039b07b7128258a3b152c42f4ded115"
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
