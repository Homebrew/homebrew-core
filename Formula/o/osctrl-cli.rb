class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "f38f76e3302f6363aac39918d4a79f7db94e9ab17179bf99ab062e3b49fd73fe"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13f55483d8b15b692578e71b275c575675eddf30beba12cf3392f703747b8752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac87e5ecbe823937349cd61ab617352ba35772063245405941a2789c9d471caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6efcaee46ae2cbe2aa3e1d6168203fa6906da450011b121914a14182b78974cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7da06329ff13883d5e251064963de2785119b0f4f3bea06825cc66d4844b652b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f39e19272a94dbefec67562291c95405c2497b7d5eb1b10cec4d2d9862887d"
    sha256 cellar: :any_skip_relocation, ventura:       "2e479fbf985f6c8537f9e149e1c2a74dedc899707cd46ed05669233858b8a98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef73022d5dd76f634815c48f48bd3e6cbd1f0c3b4820d6f0f6a74365b8a6371"
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
