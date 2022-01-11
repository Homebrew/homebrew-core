class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.5.0",
      revision: "e97261b3ebac4a3828958b06ff63d2c56a0d60b3"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c28e4a9b970053d9e9a4d1dc1fda58abeb059b636bf94547cbe54051694b5306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2448cbf08768d95639f0afc111dcb74ae3b3b54acdfc16e9d41078842fab41e5"
    sha256 cellar: :any_skip_relocation, monterey:       "691f0f6353686aacd567021cca105aa5799ccfe1df9a1db84b909fe21ff77b3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dc26ff560ec30b8f5c72c038f56887bbd3fb48535c8940012b4dd5e99ad90e7"
    sha256 cellar: :any_skip_relocation, catalina:       "560db5e9b008db385b7d357af1b48457e6cb7cb6061d88a6b1a5a77bc87d2271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf8d4e16fea3447e5b1468f96fbf8e1a3a1ccb38011257a6c01344ecfaf91ba"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

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
