class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.432",
      revision: "c7aa07c47f3a675ff2b67d571abdba991e460d3d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc9f1d419f04affaf523ded04f85ce292c17e539e23ebdf2ed0cd638622235b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc9f1d419f04affaf523ded04f85ce292c17e539e23ebdf2ed0cd638622235b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc9f1d419f04affaf523ded04f85ce292c17e539e23ebdf2ed0cd638622235b"
    sha256 cellar: :any_skip_relocation, ventura:        "74dce8c22bb2f6c33458ec16ce5e05768d0a59ec52026f3b5372c6da094bfd0c"
    sha256 cellar: :any_skip_relocation, monterey:       "74dce8c22bb2f6c33458ec16ce5e05768d0a59ec52026f3b5372c6da094bfd0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "74dce8c22bb2f6c33458ec16ce5e05768d0a59ec52026f3b5372c6da094bfd0c"
    sha256 cellar: :any_skip_relocation, catalina:       "74dce8c22bb2f6c33458ec16ce5e05768d0a59ec52026f3b5372c6da094bfd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f6020ef9f92aa1e6ccb178a5a996df57122b3ea96871ea6e15730b7fb8286a"
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
