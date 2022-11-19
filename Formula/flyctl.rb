class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.433",
      revision: "1acf701f06e3608b7ff52d604fa8a8b22c9105d3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8f10ff088798a24b8f982b727db973b67c226da689abddd252c76ab92eb4a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f10ff088798a24b8f982b727db973b67c226da689abddd252c76ab92eb4a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8f10ff088798a24b8f982b727db973b67c226da689abddd252c76ab92eb4a1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ba00f1e75f17dfe21569f08381ffb12de47d7b261956395dff9eba353685c4fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba00f1e75f17dfe21569f08381ffb12de47d7b261956395dff9eba353685c4fe"
    sha256 cellar: :any_skip_relocation, catalina:       "ba00f1e75f17dfe21569f08381ffb12de47d7b261956395dff9eba353685c4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089dd7627eaba8667c3eff37767a51ca35a51884c87bb0b640657236ef35d170"
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
