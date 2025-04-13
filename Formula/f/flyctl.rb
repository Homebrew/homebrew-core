class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.101",
      revision: "7e16f38eb984d810b21a38cef9648995b4e3d516"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5edb22fcbd074f06e429c6bb460966a337e46f299e406a39a1970937866add76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5edb22fcbd074f06e429c6bb460966a337e46f299e406a39a1970937866add76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5edb22fcbd074f06e429c6bb460966a337e46f299e406a39a1970937866add76"
    sha256 cellar: :any_skip_relocation, sonoma:        "1975a155041c73061ee1d0099da7322a165ade41d597f501133f47aaa9a09eb1"
    sha256 cellar: :any_skip_relocation, ventura:       "1975a155041c73061ee1d0099da7322a165ade41d597f501133f47aaa9a09eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46a7b9046b01fdfa46c2d407aa7cb830e93f8b8fc7c67241ba13a5fb3e0f45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab4514a22220690446dfd8ce2edaf0b76f96c167311d564725d399d7f626b14"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
