class Engram < Formula
  desc "Persistent memory system for AI coding agents"
  homepage "https://engram.gentlemanprogramming.com/"
  url "https://github.com/Gentleman-Programming/engram/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "a30998518af97f6a1d00b027e38b3738954cac341d6eb21c96089f929d1ff2ff"
  license "MIT"
  head "https://github.com/Gentleman-Programming/engram.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04b5ef5e39b579963c78216ec2dd29980060333119607700021736202bfda8ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04b5ef5e39b579963c78216ec2dd29980060333119607700021736202bfda8ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "04b5ef5e39b579963c78216ec2dd29980060333119607700021736202bfda8ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f95eb0984bc96245248c35d72446ccf07208932804372e2bca587caa7eccf7b7"
    sha256 cellar: :any,                 x86_64_linux:      "44e8bc4c2635ad772b751354f47041eb6a385a4c7871e14fc85be0f654513586"
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
