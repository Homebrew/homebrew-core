class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.469",
      revision: "ed9f95ff19f1b48701193f215a1053abfc267b1a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba1af21533b612b554e4ba55543bb4df34ff4be79510e5c4d71e01c4792d31a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba1af21533b612b554e4ba55543bb4df34ff4be79510e5c4d71e01c4792d31a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba1af21533b612b554e4ba55543bb4df34ff4be79510e5c4d71e01c4792d31a"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e28474d1ab9e850e17751232587b2c88b1656e956cfb2eeec8d935883e9f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e28474d1ab9e850e17751232587b2c88b1656e956cfb2eeec8d935883e9f4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e28474d1ab9e850e17751232587b2c88b1656e956cfb2eeec8d935883e9f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5daaa58f138255576f025b5f55ffccf5acfabe634fb33d7683bb7a992a0548"
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

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
