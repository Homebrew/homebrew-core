class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.10.0",
      revision: "0cb17e5aa89e2d6cf49cb4e7f09b602af58adfbb"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9720a991df1e6c243e511d2aa505012146cf3404b5b23a9746e47c3bc1a43729"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50d420a1a13782061e3eed7e665bf4924ff39b9ba55c7e8436361b66ac16af47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d6988eb51ecca68f526ae34505493be5cd8b74c306f48e12f87e8caef666b15"
    sha256 cellar: :any_skip_relocation, sonoma:         "825db1d91b3bd92f24d5564a56103ac328903febfbeacccb0ce8802494a7b160"
    sha256 cellar: :any_skip_relocation, ventura:        "bc199edddb362ce04fced634560d3911564bfc0f577408093e227c1128abb631"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7ac013767410c376f334a9dc803ac46120b30c14a63e1e1aab2675c8ad6fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8027f04f35b665734eb62555b26cf9296c17bf318b10d87d4857324f9aad403c"
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
