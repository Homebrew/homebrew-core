class Engram < Formula
  desc "Persistent memory system for AI coding agents"
  homepage "https://engram.gentlemanprogramming.com/"
  url "https://github.com/Gentleman-Programming/engram/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "f1661d963bd4c8970b1b12e501d8a50dfa27c1afea45ab27a2755129fba7ef14"
  license "MIT"
  head "https://github.com/Gentleman-Programming/engram.git", branch: "main"

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
