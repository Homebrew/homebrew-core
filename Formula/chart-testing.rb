class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.5.1",
      revision: "c891fb09f2c5ba548574c4bcf31229755a94e711"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c225372eb15f1546f8e5d8f5a5c2a0035955b2edbf378efad954a02c4da5126"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e2fb6c62d017c6167d205750558782fa871b75c0aee709834e8f6e6a340ac4d"
    sha256 cellar: :any_skip_relocation, monterey:       "ae47595638dca3841e79d924f13ea079f5c958052b3e43aa7afdb1efbdff34fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "39682e0b4f25506ad93e8a50bb6d178e8ae2c68f9328fa601903362b70682163"
    sha256 cellar: :any_skip_relocation, catalina:       "8f117ec2933662d8c49df81381e6ced2dc0f16e78bf4f6f6a3bc2bd440bbfaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2409b0aeab320b9841aa346b451832ed6619013fb920a2e516baa88534b4c7"
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
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
