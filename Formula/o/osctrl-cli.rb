class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "7f6e4a260f24d37f19bc955d42bb0babfc1224af43e8db7d017f21c326404df0"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf5cf504dda0a6cb34afab36c4a803746d4c7a0cfb30ac96242bbe54a88bb0e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b74cb5f28dc50f4dabeb8668f95f5037e242fc1858e59599f43c290bfea23bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9227204c43edc6e5db22090d066d52de3e608af44abe444827e95f2ed0948c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3aea34b6ddaea22e1b9c7407191fce72cb87a2aa110a86b58002d7069d0093fb"
    sha256 cellar: :any,                 x86_64_linux:      "693624b7adc4b3f8b5aa570d580d9f4b342e22d64711c59017543e90a7d1eeab"
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
