class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.447",
      revision: "8a55d4067be1d5c7c78890ea7a28ff3016d8a848"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b180926efd32b80959276b8561e67228ba55ea91faf4cc391f23a266da8a713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b180926efd32b80959276b8561e67228ba55ea91faf4cc391f23a266da8a713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b180926efd32b80959276b8561e67228ba55ea91faf4cc391f23a266da8a713"
    sha256 cellar: :any_skip_relocation, ventura:        "7c007163f5cc2dd73e0d2834fc4c25cccee931eac45a47bfd2b2ba3e267b3081"
    sha256 cellar: :any_skip_relocation, monterey:       "7c007163f5cc2dd73e0d2834fc4c25cccee931eac45a47bfd2b2ba3e267b3081"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c007163f5cc2dd73e0d2834fc4c25cccee931eac45a47bfd2b2ba3e267b3081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1eefc8bf48c7956363411f6f85ddf79e193cdeafad8a9ca837618ca67ae0cee"
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
