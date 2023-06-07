class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3bfe218335e74d070aaa17a7804adc1a90d7746e16c3b26ed54cce4b19ea75fd"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97a4f4af5262f17cacdfbe2bc2b39594a41576b152fa3b41625d1a4c211c9703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35b5a54494c4a2860b8153c165a7589acea0cb86581f9b991f4624c0c270472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aba5a791584999aa0446ec0c2c2fa94156da9d49769e496ce182ac106865049f"
    sha256 cellar: :any_skip_relocation, ventura:        "95b9afb68925438202cf2120f000abec57363ef730e7ec9e9a4d1d37e1e31e82"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4955eeacea2d4af87bd0329c26b50c8b75fc4dc7bd647b6650a07979ab1b04"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54d22ae9d2cce0da377fdf6e4b9aaa3f9377bb8a0ac600a0f3fed2698cb99d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523d7dfe4c63258ef04984394be243d7c20633099edc7ed0eeb58312f6fda858"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
