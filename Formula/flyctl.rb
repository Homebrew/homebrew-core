class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.489",
      revision: "dae9da9edfebf895003ca0c5bfa655a28c95d521"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d5d966c699261bdcd4dd314642a9c14eacc3ea444717f65762ce672fe62cdbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5d966c699261bdcd4dd314642a9c14eacc3ea444717f65762ce672fe62cdbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d5d966c699261bdcd4dd314642a9c14eacc3ea444717f65762ce672fe62cdbe"
    sha256 cellar: :any_skip_relocation, ventura:        "989b5e8f140d780e97467ba104bd3e6f9acf6062e69cc68e7cccac64b59b6ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "989b5e8f140d780e97467ba104bd3e6f9acf6062e69cc68e7cccac64b59b6ffd"
    sha256 cellar: :any_skip_relocation, big_sur:        "989b5e8f140d780e97467ba104bd3e6f9acf6062e69cc68e7cccac64b59b6ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca362af87c41c1c8fb01315c04b95793c0194db36827418934bf235c336b5ee4"
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
