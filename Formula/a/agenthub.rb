class Agenthub < Formula
  desc "CLI for provisioning and operating AgentHub environments"
  homepage "https://github.com/morshoto/agenthub"
  url "https://github.com/morshoto/agenthub/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "173fcee428bed572235202b51433e8d753ae91701514f897079dcf966c6958a8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X agenthub/internal/app.Version=v#{version}
      -X agenthub/internal/app.CommitSHA=unknown
      -X agenthub/internal/app.BuildDate=unknown
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agenthub"
  end

  test do
    output = shell_output("#{bin}/agenthub version")
    assert_match "agenthub v#{version}", output
    assert_match "commit: unknown", output
    assert_match "build date: unknown", output
  end
end
