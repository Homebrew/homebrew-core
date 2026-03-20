class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.19.9.tar.gz"
  sha256 "faf3fb713d1f6609bfd8820074e4685a26a2c389d8c26ad1fef379d06025d766"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bccaf9578242f8b9af469454c64ac919afaf4d54338f5396920f1efa083612f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb27786a411f0074cafd2f9a0a89f616c33d509766e4ecf32d4948ffae10acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2fa254fd89a9e8b35d1d94dceb89bd10d40f3d3b8edf7920ad90b0a1a1eca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0525c01dcd355424d63783ec14985a7d9611c742d3b63c29ea1af9026b16c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b288d339d8d27d8effe6b28777e2c22f784fd304c280864be1553c547343f01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03668e9e5c6a3c85802ffeda076a5d584358a277ae0745a2691109eed9f1a14"
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
