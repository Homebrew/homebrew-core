class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.366",
      revision: "bb67f8d30f6c53ec12d75f15529a03d24fcba4b7"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a322cb6f52d8c1f7e08f3e5d39548713f29a2c0fc6a842e21f8baa2f7f1c5ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a322cb6f52d8c1f7e08f3e5d39548713f29a2c0fc6a842e21f8baa2f7f1c5ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "367df6829d889d16d6c818b1615bf59a4c7f69dde79d15b751ef130f06031f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "367df6829d889d16d6c818b1615bf59a4c7f69dde79d15b751ef130f06031f0a"
    sha256 cellar: :any_skip_relocation, catalina:       "367df6829d889d16d6c818b1615bf59a4c7f69dde79d15b751ef130f06031f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b37595151a3b5505837150a75260b500e23daf288217002a5abb7e363ee7c4ef"
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
