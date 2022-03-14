class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.5.1",
      revision: "c891fb09f2c5ba548574c4bcf31229755a94e711"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a952a013cdca3607e50fc891feb37e53f095ee5feb5d389e7172408faf4ca2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6353994158dce52ebb39ed9b349572f948ea1eb6aefae379919845f74bcd8934"
    sha256 cellar: :any_skip_relocation, monterey:       "e5bc4a1590a4b3230caf43e1dd551c46f4b22a510db21164b8ad7be7d9e0c0fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7953cdb4762204e168677390434d95f7d274f63c6fe39f175158ece267fcea06"
    sha256 cellar: :any_skip_relocation, catalina:       "64021f365503221f021e146f870d578480217ee313bfc0ae81903552e10f6b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b50ea823b97f1aeaee64823069080b3e7a881d6f92dfa4837971dbdbb63820"
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
