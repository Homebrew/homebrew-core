class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.6.1",
      revision: "d32315e6671030780095222d84f7280c23491dd4"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6941535a65f93badb692d8406cb660a2e2bac95a104d141875706cfe74b666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e6941535a65f93badb692d8406cb660a2e2bac95a104d141875706cfe74b666"
    sha256 cellar: :any_skip_relocation, monterey:       "f96707b73294e5fe0a0fea4211faa7bfc5569113189d364dc1f60ba134dcc900"
    sha256 cellar: :any_skip_relocation, big_sur:        "f96707b73294e5fe0a0fea4211faa7bfc5569113189d364dc1f60ba134dcc900"
    sha256 cellar: :any_skip_relocation, catalina:       "f96707b73294e5fe0a0fea4211faa7bfc5569113189d364dc1f60ba134dcc900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df28106af37511f83eb18d3a53038dd56abc73ab2e7b02cca071cefeaf1fbbf7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags: ldflags), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
