class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.9.tar.gz"
  sha256 "d1b98511bd0e7c9fda9bb43f97de58237f3f5cd8cc2d98da7a8b7390276f122e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cfbc01aa851ba4be477183dcbc2cb25c41089d37bb18b2ac6bc7586b42c4f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a460772cbd7ef443685c14ca6d682fb840200a2b5d27915e5cf7168f250834d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bfa6c1ceb00bd197c560d2e09b314da2a1ed8c4fe0f64d93b91fbd96085d460"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e4d81f3785c90a59ea808f780811db79e62ece03c2e6b6edaaa5ae5b121cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57362d8184c9acefb67edd4559a3c68f68403c1ada641dbf9d6a0ff28ec05ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5ceec12a33f04b6df9ac58d18746ec7caceb87a56c80deadcd30084b660911"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
