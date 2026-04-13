class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "c409c0827787e232ec9f3dc87871337cebe228b725cc2f3e1dab4f1936aad3e5"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c20dd51d1b0b71fe7f0b0bd8e5ff739155ff3d19afd0ec065fd6573db8eadc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9dffb2770e2de9285cd539d4a75bb719530df22faef2c88676846abd84f065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac1dcc67443b29dd12a5646b258cdc6f4c8af57a06fe3f6c4e0e50633ac9a57"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31da603ff5374380276907d3aebc5aeab0741e7c0d6b1be6d758565a3fed84f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73f5cd8787040812646485bb12e6ae35ab9cc03ea117c017ae8067c25511cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700c52a5e69ecb7b5a39f2e31f5ad86f5c18c1fea57f5429152e75699ea3de6a"
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
