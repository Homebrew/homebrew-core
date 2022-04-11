class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.317",
      revision: "eb09289f9a7c9b519ccc19ed6506882751645d33"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb870802df5acf376c8e63e0cf0204d145ccf1ac6346cd666f508ff1fac1e11f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb870802df5acf376c8e63e0cf0204d145ccf1ac6346cd666f508ff1fac1e11f"
    sha256 cellar: :any_skip_relocation, monterey:       "e33c8c1fae8169bfdb5faef218005b5e6464ef438af7a71e3cfaa4d14ac074f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33c8c1fae8169bfdb5faef218005b5e6464ef438af7a71e3cfaa4d14ac074f8"
    sha256 cellar: :any_skip_relocation, catalina:       "e33c8c1fae8169bfdb5faef218005b5e6464ef438af7a71e3cfaa4d14ac074f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385544428ae2d0bf7c713bf1efd10f92ac9eab2c306419425b501ef0c60394cc"
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

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
