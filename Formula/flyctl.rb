class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.409",
      revision: "7de388a47c40c17aa9f62dc3b0f824606c65461d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa40bc5956db1f2dbf43108d10b9e9cdc35967a93d2adee2620996f1b709a2e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa40bc5956db1f2dbf43108d10b9e9cdc35967a93d2adee2620996f1b709a2e0"
    sha256 cellar: :any_skip_relocation, monterey:       "53bcad8f12a0d9e6ee261891b81b74cdc45a8a691c3d86828afc0accbbb5fb7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "53bcad8f12a0d9e6ee261891b81b74cdc45a8a691c3d86828afc0accbbb5fb7d"
    sha256 cellar: :any_skip_relocation, catalina:       "53bcad8f12a0d9e6ee261891b81b74cdc45a8a691c3d86828afc0accbbb5fb7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471cb58c72c3db779965e9c37d61f98cd4f2c253e05ba1cf5c7e33fbe40d4b30"
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
