class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.110",
      revision: "31e7022b2ed3b929fc05826dde1796681d9229de"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba77355627fffdc940e6e6f8ba643656ef4908e11d25cc9fccf27dee86793187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba77355627fffdc940e6e6f8ba643656ef4908e11d25cc9fccf27dee86793187"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba77355627fffdc940e6e6f8ba643656ef4908e11d25cc9fccf27dee86793187"
    sha256 cellar: :any_skip_relocation, sonoma:        "630dc66cfe23d6698c4829c3b24b5816746272a7de1b1882d2c8eadac69188ee"
    sha256 cellar: :any_skip_relocation, ventura:       "630dc66cfe23d6698c4829c3b24b5816746272a7de1b1882d2c8eadac69188ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "007258041623c6b2b77b813e54ad1fe6f1948e1f291c09339cc9fe09907d48b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7def4bd46044b496f427a2c367e3b00357632f666f00f17ab2555867090eff87"
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
