class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c90d551f4c7e142d0edf33ce39d3760ffb852ab22a88ad04165e159d44455076"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "918cc4970f4144f7a3486167e19835edaf3e757e21a0c38753e05d07c908baf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36f7c49a38a4db43af6cb055a05ac5926b70f4e02be0b78bf3e105542b5b8deb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6b187a3c9bcc242f33ef94d1e4b0c66405037e7703db7fc7c1581c8c9d9dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39fc412fbb38d64fda1653f4e0268dc22f6616902ccdc16d26a925e9e3cf8b79"
    sha256 cellar: :any_skip_relocation, sonoma:         "97f65c59a709ef78f944b05414271a2038562291ffcd7c3a62d1690b35383e99"
    sha256 cellar: :any_skip_relocation, ventura:        "622444239281063b9ea2fc3f7cb24d10179cc042fc5d169f69c2103c29d194c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a23ff8736f9b2503b8f16102df34759eccc3b0c0104ab214fb5ecc2123be455f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fb86346bc669151f33d6f82182808bd9f42dce017829449a79900c41abd51cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1796bc25f20a13613f626417dae775c8410aa5c257be48065f3e645a4b6829ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
