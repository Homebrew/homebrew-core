class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.471",
      revision: "80cad976c5886179d7f77da369ca91d94941c63a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8b34fc4db2f02469270858bf626022826db77d43958a0c1a6e64b3d609c5d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8b34fc4db2f02469270858bf626022826db77d43958a0c1a6e64b3d609c5d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b34fc4db2f02469270858bf626022826db77d43958a0c1a6e64b3d609c5d84"
    sha256 cellar: :any_skip_relocation, ventura:        "24873ad1cfc999100e1b4cd62c7b9d8950d39d1e5cb867645c6c503c1c393cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "24873ad1cfc999100e1b4cd62c7b9d8950d39d1e5cb867645c6c503c1c393cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "24873ad1cfc999100e1b4cd62c7b9d8950d39d1e5cb867645c6c503c1c393cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66e404e5f9e40fb6593fd19437354e217cb7d1636126777843a0518e2f722ad"
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
