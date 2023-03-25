class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.8.0",
      revision: "7f3a83ddc506713b7f7f1534f224dff78fead215"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7147fd85177ad3ceb8e5325a5d5616a87b2ba1782e27ff691cc636aa397c1481"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7147fd85177ad3ceb8e5325a5d5616a87b2ba1782e27ff691cc636aa397c1481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7147fd85177ad3ceb8e5325a5d5616a87b2ba1782e27ff691cc636aa397c1481"
    sha256 cellar: :any_skip_relocation, ventura:        "64ce0a3c3308596396ea4334f0301f251b4d786f9b54fa47ec34e8faafd41d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "64ce0a3c3308596396ea4334f0301f251b4d786f9b54fa47ec34e8faafd41d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "64ce0a3c3308596396ea4334f0301f251b4d786f9b54fa47ec34e8faafd41d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6397f3c0e5961d657a9c0f7f9d9dd05851725482874aca3ceedd04240255e2c5"
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
