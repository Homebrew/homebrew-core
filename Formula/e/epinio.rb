class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f4e8bd1daf855be98a389920a2d3ea504b7a33e01f0aa8b14a9e536e2232696e"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16cd2d8c17f264eb6212137534b47931dd67ffd30a2da04ab85cc36a7ac05a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401e58b70b09d46c901bfd3b72f401660d8e28bd542e71d114175c065f35f1d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7c5b2965f92d18231ddde73ea7317dc4edccada95e82b967b5b365717187d05"
    sha256 cellar: :any_skip_relocation, ventura:        "ebf1e33d33053a105300a709cee642f838c0b465bf15f659f538ba4201f3902f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d458af201c865412339eca336d4c6e419a420f331ef65d553af9fc376ebf640"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f75df9fe09bc8ef49532df50cf6bc721b33bf8ed1f70855734ad80cd30cb258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf4ea5222e2db10adc44cc698150589824d708071e26f03bd5103ab61713dbc"
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
