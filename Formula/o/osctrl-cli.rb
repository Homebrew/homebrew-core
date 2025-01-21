class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "afc854ecef0d877f5b56ae93b9e9b115964d8fa1a9762b5e40fc9ef4f0e2f1d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8d5f1045e561c7be280f0c211f5cbe9b3206892bd0b315eedcdd6263e76611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c8d5f1045e561c7be280f0c211f5cbe9b3206892bd0b315eedcdd6263e76611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c8d5f1045e561c7be280f0c211f5cbe9b3206892bd0b315eedcdd6263e76611"
    sha256 cellar: :any_skip_relocation, sonoma:        "728c62d39a674d59bb5191ba2d00234c8cc4a4cf5006baf2e74ce23d1fe0a9b6"
    sha256 cellar: :any_skip_relocation, ventura:       "728c62d39a674d59bb5191ba2d00234c8cc4a4cf5006baf2e74ce23d1fe0a9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94cbc386481347069fa4f4fb2b6a75f23802f12d5fdbf8c9dcae2dcb85ce40a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end
