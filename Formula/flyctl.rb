class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.435",
      revision: "c51496292b7885982e3f0994f7a548424abb908a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4376f2dc85584cbd7f3fbf59bb2e867352e5791139f0b2d6f956a09d9c203709"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4376f2dc85584cbd7f3fbf59bb2e867352e5791139f0b2d6f956a09d9c203709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4376f2dc85584cbd7f3fbf59bb2e867352e5791139f0b2d6f956a09d9c203709"
    sha256 cellar: :any_skip_relocation, monterey:       "a297312026a5d36cc346ab367e751c3b63bbf9bc22b20e56861de31552308e0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a297312026a5d36cc346ab367e751c3b63bbf9bc22b20e56861de31552308e0d"
    sha256 cellar: :any_skip_relocation, catalina:       "a297312026a5d36cc346ab367e751c3b63bbf9bc22b20e56861de31552308e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a753b0e7241573297113921ef1083aa82100a9ee372f1096315a3a09a16853c1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
