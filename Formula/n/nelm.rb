class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "cd122f03d2ce21b85842fd633b211a38594a5d27e49a69e2802566930c42c463"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e47273657ae157b65b0dc3d52d82d1e8e6aafe6c9f70d1eb32301b23f108b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b8ba8faab455fd148fd03b42e66f98da2a994850ecc1ad11fbea1e49c9678f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27856e559d003cbd65e23c3dbd32fef17d4058a1e6575ca0fc43e9bc65d3e0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e588f28934108145b457f565385d550245f7b288f7c044bf834daf2413d3312c"
    sha256 cellar: :any_skip_relocation, ventura:       "941c84db2a061e10f06b9276dde6a19fff63250e84bb22f115ede8b5c69f076f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80267dccd78d45c3c8d92dbb3f8a4aff750012673a6275b464a0e627cae7930e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93eeda7213a690716ac693e795065e747ca7efa7c163a3ac6438d8652f88c18"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
