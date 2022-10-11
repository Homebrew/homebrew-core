class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.410",
      revision: "3c67527aca1d7848584436f8fbcc15a760db7691"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "815a82e5ec1125a222951f64e571b3e8dc5818fc2bede9d54e5219d95caca213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "815a82e5ec1125a222951f64e571b3e8dc5818fc2bede9d54e5219d95caca213"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d1570a0332e4ecdae4b3743c3ef23b5dc3d85028698a0a7c9419d1b518f676"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0d1570a0332e4ecdae4b3743c3ef23b5dc3d85028698a0a7c9419d1b518f676"
    sha256 cellar: :any_skip_relocation, catalina:       "b0d1570a0332e4ecdae4b3743c3ef23b5dc3d85028698a0a7c9419d1b518f676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da4d4e56d5934db89dcad3499d18c96d8eb377310772ca2cd2afa432e284add"
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
