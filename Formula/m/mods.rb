class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e16268ce55b9c90395116c2c8ce4d820d18d7f0b05430d64dc69686410776231"
  license "MIT"
  head "https://github.com/charmbracelet/mods.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cabb69b0f13a40d880de4f499d8858967b59f9eb53dead33c2791991cbaeb533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cabb69b0f13a40d880de4f499d8858967b59f9eb53dead33c2791991cbaeb533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cabb69b0f13a40d880de4f499d8858967b59f9eb53dead33c2791991cbaeb533"
    sha256 cellar: :any_skip_relocation, sonoma:        "13855735a91fc4ec39118e17e99c3fe874153c1733629a012987709030927045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d5d54b0ff3b4722747d5bdc33ff27c985e3c836c31028d0763048a5908a401f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89100e59be7a746933965396dfbebcab35529ae7559329ac77c5df814d594d53"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mods", shell_parameter_format: :cobra)
  end

  test do
    output = pipe_output("#{bin}/mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  OpenAI authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/mods --version")
    assert_match "GPT on the command line", shell_output("#{bin}/mods --help")
  end
end
