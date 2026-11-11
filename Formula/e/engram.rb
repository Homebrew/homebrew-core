class Engram < Formula
  desc "Persistent memory system for AI coding agents"
  homepage "https://engram.gentlemanprogramming.com/"
  url "https://github.com/Gentleman-Programming/engram/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "f1661d963bd4c8970b1b12e501d8a50dfa27c1afea45ab27a2755129fba7ef14"
  license "MIT"
  head "https://github.com/Gentleman-Programming/engram.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d22eb184f65a9f8ed3726d484724d2b88a4af5b4f3cbb6120dfca6cdbbfc7920"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d22eb184f65a9f8ed3726d484724d2b88a4af5b4f3cbb6120dfca6cdbbfc7920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d22eb184f65a9f8ed3726d484724d2b88a4af5b4f3cbb6120dfca6cdbbfc7920"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb965095748db9fd0ccc30d4caf2b3dab4c0437da59d2d9b435f9f8b9e48146f"
    sha256 cellar: :any,                 x86_64_linux:      "3d75f5fa3ac7ecaa0b71ea6896cc21464fe321b558839a80c0e3aa6dbc4bb5f2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Homebrew manages upgrades, so disable the update check
    inreplace "internal/version/check.go", "if updateCheckDisabled() {", "if true {"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/engram"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/engram version")

    ENV["ENGRAM_DATA_DIR"] = testpath/"data"
    assert_match "Memory saved", shell_output("#{bin}/engram save 'Brew test' 'Homebrew formula test' 2>&1")
    output = shell_output("#{bin}/engram search Homebrew 2>&1")
    assert_match "Found 1 memories", output
    refute_match "Could not check for updates", output
  end
end
