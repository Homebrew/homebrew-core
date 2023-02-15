class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.457",
      revision: "f58a2e68b3cec6c2befcbe5e978b259cdd2f970a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4a1ce6bf01afc644d9c7d4a15cbf8d4485615894ddb1a1f87d23dba5211aef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4761169781914296ab996f15111d95f980bdb66172d38c2b3778a92ccaaec687"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f924d3a2625bdeaf9c3adf173e6a88358b9ee24aca64a15054ab4ac031a2c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ed4ca8b488c9d75227d0156bd08f4d6cac0173e7d98f4a0537418b3ffb9c7f71"
    sha256 cellar: :any_skip_relocation, monterey:       "f4270795a685596f021da67bbfe8f8465a97049f43b175ba7701efddfecc3ef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a16b0359ebdfda7af924d6fa9c6d15670ddcc406492cb6f8671ab05b3d5a3c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4f1b3eb12b951655d191638ad04bf206c7b91d153e365f698035d841c67f0c"
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
