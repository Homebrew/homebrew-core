class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.419",
      revision: "3d8f42a9eb3a647b2b452666f14b322f2054f171"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df152b4c784428c5841e9363c7a78e55450b61804deeb3000d7fc935c32aa92a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df152b4c784428c5841e9363c7a78e55450b61804deeb3000d7fc935c32aa92a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df152b4c784428c5841e9363c7a78e55450b61804deeb3000d7fc935c32aa92a"
    sha256 cellar: :any_skip_relocation, monterey:       "1e016c3bd18d26520cfca82e5e701b0a537572a9d7151f5d9c23092e0aa042c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e016c3bd18d26520cfca82e5e701b0a537572a9d7151f5d9c23092e0aa042c6"
    sha256 cellar: :any_skip_relocation, catalina:       "1e016c3bd18d26520cfca82e5e701b0a537572a9d7151f5d9c23092e0aa042c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3015293260697ca46b91d4dcac09773921ab125dfb5940ea524b90bef7af4318"
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
