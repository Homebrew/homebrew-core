class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.470",
      revision: "5b41efb9047034ac53e7f0948bb249efc02618c7"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409546609dd810f6155c77865e94d421559c326c3994f9664b26aa5809d67dfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "409546609dd810f6155c77865e94d421559c326c3994f9664b26aa5809d67dfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "409546609dd810f6155c77865e94d421559c326c3994f9664b26aa5809d67dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "9d2f64357583c0c3bda2cdd176ed01c9f3ae8aa7effad895df6365ad2972d2da"
    sha256 cellar: :any_skip_relocation, monterey:       "9d2f64357583c0c3bda2cdd176ed01c9f3ae8aa7effad895df6365ad2972d2da"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d2f64357583c0c3bda2cdd176ed01c9f3ae8aa7effad895df6365ad2972d2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1fa318ea24e90b739a4d565ba015d43c7d1cf4c557881470f04a2f525ccf02"
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
