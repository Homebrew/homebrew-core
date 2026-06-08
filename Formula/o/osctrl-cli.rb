class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "0104c25a1a08c5cee4db3ee070fdded7d35bbde9b9296eab6e035fe2a4d3ceac"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fddbaf663a1018dc9fddbb2ccd3c47d7beab026d30f697cceeb7f48edecb006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ac3ee42a006f169c442a54cdf6a318ce488b7dda81c76b5b07c0404780bf7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae05e0e391c51c2bb66f397a178557d4dd08ece01318781ca562f3a311691d69"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a329b69ade5aae1f27a52cce940812a9de933c3005fa4b363a1824cdc3c352c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa3ec60592ea221443c666ea782d83da29480303ef9effebd5bb267c0ca416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "174076558ae8a1b307c5f8a46301f6fa1b989db61b2ea65136bbac7b06d13c53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
