class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.498",
      revision: "b43d6fcafe1b322810d91395658f4af36c783133"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebcbede4fb1053d50247c212002f020233f8334d4d846de1d5731c724a548a8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebcbede4fb1053d50247c212002f020233f8334d4d846de1d5731c724a548a8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebcbede4fb1053d50247c212002f020233f8334d4d846de1d5731c724a548a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5a56c121f45c0c82f272c6c6c4af0f96425685195d759ce95d329746dea342"
    sha256 cellar: :any_skip_relocation, monterey:       "cd5a56c121f45c0c82f272c6c6c4af0f96425685195d759ce95d329746dea342"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd5a56c121f45c0c82f272c6c6c4af0f96425685195d759ce95d329746dea342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d75c04f4e22b52d35d549d44e4dc0541015097394f3d518d6ed13b357447a5"
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
