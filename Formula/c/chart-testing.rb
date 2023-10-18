class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.9.0",
      revision: "88cc7026481da7468e34a614b8ca4f0da42c063c"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0a8a71248826f05587f214bd75ce7580e5d94e6202042ffc91fc6bb31953d55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cdcc408a6a87349a6e42f4e0c81967274a34569b9ed00f0b7064320463fa42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdcc408a6a87349a6e42f4e0c81967274a34569b9ed00f0b7064320463fa42c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cdcc408a6a87349a6e42f4e0c81967274a34569b9ed00f0b7064320463fa42c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb3811550e29c7c2e61afb6c1fb2847018ede40ba271aa7a5c264d91b97a3d32"
    sha256 cellar: :any_skip_relocation, ventura:        "5908cc67c2a3664c1ec17f437537703c67779852bb00a5fe27131d2daef434a5"
    sha256 cellar: :any_skip_relocation, monterey:       "5908cc67c2a3664c1ec17f437537703c67779852bb00a5fe27131d2daef434a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5908cc67c2a3664c1ec17f437537703c67779852bb00a5fe27131d2daef434a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5317a23611aed11ccb204e575df76e5e2f3742624f75f1065af45c08e9df6c4c"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test
  depends_on "yamale"

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkg/config/config.go", "/usr/local/etc", etc
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{Utils.git_head}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{time.strftime("%F")}
    ]
    system "go", "build", *std_go_args(output: bin/"ct", ldflags: ldflags), "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match(/Version:\s+#{version}/, shell_output("#{bin}/ct version"))

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false " \
                          "--validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
