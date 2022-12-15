class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.440",
      revision: "eb879bff60ef4cf348ece198063b3ea9a53a2f57"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46c212fcec94843809123a0cbd8f35676c7a84dd8f62241307a5b167130bc25a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c212fcec94843809123a0cbd8f35676c7a84dd8f62241307a5b167130bc25a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c212fcec94843809123a0cbd8f35676c7a84dd8f62241307a5b167130bc25a"
    sha256 cellar: :any_skip_relocation, ventura:        "5fa8159f99707604a76e51a0c416cd26da20ee05212108306f621d6d6f6b1a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa8159f99707604a76e51a0c416cd26da20ee05212108306f621d6d6f6b1a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa8159f99707604a76e51a0c416cd26da20ee05212108306f621d6d6f6b1a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f2ef688ba1ebfba6f3a7fc0bd3f4bbd76285422cd95fc94d7e976d0ee13319"
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
