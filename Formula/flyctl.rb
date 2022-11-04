class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.429",
      revision: "6db701e0f60537a15cc03c42bbd8dd4d8e5c18dd"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30aeba260ae5b2dd2cd319ea01df483d38a9647c284a727d7f1a0765c3e63d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30aeba260ae5b2dd2cd319ea01df483d38a9647c284a727d7f1a0765c3e63d54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30aeba260ae5b2dd2cd319ea01df483d38a9647c284a727d7f1a0765c3e63d54"
    sha256 cellar: :any_skip_relocation, monterey:       "fb48b53ea460f9c2c6e05d67c88fb8e6020a32ba5668810d37367930c77d4d42"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb48b53ea460f9c2c6e05d67c88fb8e6020a32ba5668810d37367930c77d4d42"
    sha256 cellar: :any_skip_relocation, catalina:       "fb48b53ea460f9c2c6e05d67c88fb8e6020a32ba5668810d37367930c77d4d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb6829d15956217b1ef79491b571d65a6d6f8ba88d36a98996a95c375c62d37"
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
