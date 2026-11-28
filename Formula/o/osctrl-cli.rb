class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4b10ac68bf33c6bd8239485871a46517ba8c26362a605f836c1619deeeb814a8"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    manifest_sha256 "4c3a7005cce44ae6e9d3d7e29075041909a7b56eb9bcd2b6b63dd224a0fdf336"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5842f326bfbddb666142b2288f3c4b1c8d8e07e7227848e4faeebbd4ff5b271e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aae2e58d752a3c32a29492149e0ef33b36ce97a39cdab23b8368196ab7f80f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a154cd5d6bf95892a19177d33d70e52e030d9acad2c90bbe9c26782c750364e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b72e57a229c48f0e97cde9e7e6d773b2423c22f101ea823ca206f1202904a431"
    sha256 cellar: :any,                 x86_64_linux:      "4043961e8bdda2f339fde35085b8c6cd7297df8089d6f65c5d8456c274592c68"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_head : Utils::Git.get_tar_commit_id(cached_download)
    ldflags = %W[
      -X main.buildVersion=#{version}
      -X main.buildCommit=#{commit}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
