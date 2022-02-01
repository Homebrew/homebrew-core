class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.3.2",
      revision: "272db4732b90390232ed9bdba955877f46a50552"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8504c11f50dcfb6faf86b6620a8edbaa7cd3f0ede4e37620446ce358fbca170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dba1b14bff095ee5e58d748983ce06bf33bec0bc172c1d5e04afa9d1bc23c554"
    sha256 cellar: :any_skip_relocation, monterey:       "e8057808c82af4968745194e40edbf045faf7427b74f728af97ae5f5773608b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "36985a1ab428e54e4f8b23ce3ff33e5a03121e0aa131cf21256c2e27f4809892"
    sha256 cellar: :any_skip_relocation, catalina:       "ea8f6b7b4a9d4ac03e49775b4fcfbba20763990057426818641529a911da93bd"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on :macos

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    (bash_completion/"colima").write Utils.safe_popen_read(bin/"colima", "completion", "bash")
    (zsh_completion/"_colima").write Utils.safe_popen_read(bin/"colima", "completion", "zsh")
    (fish_completion/"colima.fish").write Utils.safe_popen_read(bin/"colima", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
