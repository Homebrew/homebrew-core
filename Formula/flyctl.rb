class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.510",
      revision: "22b9ee7318a9ec036a49bc8bc35fa3e6f324c0d4"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b850be2ed5ec614a5e32ed8c502fb487275a761175af8108c5f3b1ef760bbb9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b850be2ed5ec614a5e32ed8c502fb487275a761175af8108c5f3b1ef760bbb9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b850be2ed5ec614a5e32ed8c502fb487275a761175af8108c5f3b1ef760bbb9b"
    sha256 cellar: :any_skip_relocation, ventura:        "3556cc89bb0a83942f1e9d6e3ff860e2a3264f8fc41586765eddb81dbb23c262"
    sha256 cellar: :any_skip_relocation, monterey:       "3556cc89bb0a83942f1e9d6e3ff860e2a3264f8fc41586765eddb81dbb23c262"
    sha256 cellar: :any_skip_relocation, big_sur:        "3556cc89bb0a83942f1e9d6e3ff860e2a3264f8fc41586765eddb81dbb23c262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0927e16e56947bedbc18dfc5b384ac0877495dc757387e2ed0c9bb57547cc6f5"
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
