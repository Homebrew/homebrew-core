class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.1.1",
      revision: "3fc5a5010805e92d099ecacfba57b7c60c12d44a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec0538becd4578009f8b9928b324fdd0eef66c94668ca74f072c339974c9a343" => :catalina
    sha256 "df94b17e1da3410a44ac91a711c3ec8c507d2a32d8f01a660ce0e0ac640837aa" => :mojave
    sha256 "e431688deb0a4de84d7ff6203e8399a8559f307ad672f6950e4568c32a0708b5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{commit}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{Date.today}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"ct", "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match /Version:\s+#{version}/, shell_output("#{bin}/ct version")

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
