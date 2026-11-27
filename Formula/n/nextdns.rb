class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "46ab8b64c36bb1db8fe6cd3b6ded9fbbd2af7c3ab4960c01e566ff2969fe97ee"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "a5b22dadf1715956f071409cc627f0c47cdecc87d6446e929bf791fd5bf64293"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2daf3f9593a8622cee095e2f0686a09a3206749a2bebbefc615226787f2a025e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41269034e2b8263f1e3185ee3f0bc8010fb85f8c8694cb97be396fecd96d8295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b1c922b306a564759d0256bf459d19f8b93a26c73d49a2c2a313315f8476253"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "186ab7e24f8d6ce927cdc05ba1319846d495fede498c278c260a30b04983fe50"
    sha256 cellar: :any,                 x86_64_linux:      "e2dc92fde1f0d15fc25e9d8ea475bf23648f4fae317e8f41ada41d5426df33b0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
