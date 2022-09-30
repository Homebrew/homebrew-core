class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.400",
      revision: "eef41ec7a5a149541a896a00faf2eef3c4e7db9c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3570f0c35b583aa978b9d937922a0de31e0fc175bc87fa38d5f81adb061199c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3570f0c35b583aa978b9d937922a0de31e0fc175bc87fa38d5f81adb061199c5"
    sha256 cellar: :any_skip_relocation, monterey:       "380fdff2d3e53c5cef1899e75436790a34f447f50c549abea5ddf9a245846f05"
    sha256 cellar: :any_skip_relocation, big_sur:        "380fdff2d3e53c5cef1899e75436790a34f447f50c549abea5ddf9a245846f05"
    sha256 cellar: :any_skip_relocation, catalina:       "380fdff2d3e53c5cef1899e75436790a34f447f50c549abea5ddf9a245846f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e268030890a63218bdbab23c9802c2e13937f54e8facb15f56173ac18eb9d09"
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
