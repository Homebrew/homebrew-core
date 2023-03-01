class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.474",
      revision: "dc3a37a716df9f63da64538f20614adbc4f263b1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e474ab7abfc30aa33c026af7546b25c9ed12100d5aff39f8376ae27efe737e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e474ab7abfc30aa33c026af7546b25c9ed12100d5aff39f8376ae27efe737e53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e474ab7abfc30aa33c026af7546b25c9ed12100d5aff39f8376ae27efe737e53"
    sha256 cellar: :any_skip_relocation, ventura:        "ce161d3541de3994ac15ad38009de269bc31954eea5e3f257889576b5d7c1e82"
    sha256 cellar: :any_skip_relocation, monterey:       "ce161d3541de3994ac15ad38009de269bc31954eea5e3f257889576b5d7c1e82"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce161d3541de3994ac15ad38009de269bc31954eea5e3f257889576b5d7c1e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1415c08a3f26063c4e32639aed675fea105ad785fe6ea9ade0ac629149f526de"
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
