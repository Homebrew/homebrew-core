class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.426",
      revision: "dd396512f1d895922f4468475a7a02a3dd9bf942"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "748ee67b1c5b07814ad2858515ecb8468983010c739ea470b3140d76f21fd48b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "748ee67b1c5b07814ad2858515ecb8468983010c739ea470b3140d76f21fd48b"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd2dc8baf38df9f71d592b3837d6b4116dd3606b93e7d329d8f25a0e148b0db"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbd2dc8baf38df9f71d592b3837d6b4116dd3606b93e7d329d8f25a0e148b0db"
    sha256 cellar: :any_skip_relocation, catalina:       "cbd2dc8baf38df9f71d592b3837d6b4116dd3606b93e7d329d8f25a0e148b0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb798e8960798d58832b0d683df27db9f5f8c8e889f687ad3761d34d344c00d"
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
