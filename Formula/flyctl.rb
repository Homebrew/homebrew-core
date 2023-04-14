class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.520",
      revision: "6494909ac73408823b6c2e2a46ca6a532aec0e73"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0b9f521e1e76dbe46b8872a486a8930988ec54d097be6175801f6378ee4f942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0b9f521e1e76dbe46b8872a486a8930988ec54d097be6175801f6378ee4f942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0b9f521e1e76dbe46b8872a486a8930988ec54d097be6175801f6378ee4f942"
    sha256 cellar: :any_skip_relocation, ventura:        "cc69f717bef90cd09b55d4147997533edc384398986be31e23f64d394c6d283b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc69f717bef90cd09b55d4147997533edc384398986be31e23f64d394c6d283b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc69f717bef90cd09b55d4147997533edc384398986be31e23f64d394c6d283b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23097e78991587222c9ea6f0679bd30193a34861c08507fdcce242e67105e259"
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
