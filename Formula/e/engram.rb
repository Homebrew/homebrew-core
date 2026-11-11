class Engram < Formula
  desc "Persistent memory system for AI coding agents"
  homepage "https://engram.gentlemanprogramming.com/"
  url "https://github.com/Gentleman-Programming/engram/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "f718361040689c79c78b14baca351791063d6e21986a4b419e7de3f0fa126d34"
  license "MIT"
  head "https://github.com/Gentleman-Programming/engram.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2a7944137f0f410534c4ed99a32f006f50a179d621644f07d1f4821e8bd166f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2a7944137f0f410534c4ed99a32f006f50a179d621644f07d1f4821e8bd166f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2a7944137f0f410534c4ed99a32f006f50a179d621644f07d1f4821e8bd166f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d87841a194130ec29ecd273706a12a35c6f6b4df5d1d10f2fe6a45bf2db9e22"
    sha256 cellar: :any,                 x86_64_linux:      "fe5433d940b2d316519688e6dd6f431eafd8f0c4681715978fda6cccfc0836e7"
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
