class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "076dd214fe19f4e4796d1f694575898bc1409642c9e2ba06c439e224525a5a82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5056fcdfc80844c52bfe8f6283d97a40603fe859abc163c2206d9e382dba36ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5056fcdfc80844c52bfe8f6283d97a40603fe859abc163c2206d9e382dba36ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5056fcdfc80844c52bfe8f6283d97a40603fe859abc163c2206d9e382dba36ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4fb0d5a2def970f800cf1281d1782384c0a0dda426702e01fe7e601b16fc395"
    sha256 cellar: :any,                 x86_64_linux:      "ff28010bc8743b3b10526b07b72f4f1b14c751f6f46ec0658abf5dc12c5fdace"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
