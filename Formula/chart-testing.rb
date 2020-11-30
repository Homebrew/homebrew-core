class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.3.1",
      revision: "71d0e1e82c5c8b66ce4d9704426dc13b7075829d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db5969dbd5a298a2ba69352776111842895f409d219d98c05c6a95f66679174" => :big_sur
    sha256 "f31d43837c0e6a7e2d01e92807f8a78663fca8fd7c4c6fd1fe48f683cad19637" => :catalina
    sha256 "def80e2b612e4304ee5a670eee3ab435b885ef2e6db0af6c6b95f3ff91a3f722" => :mojave
    sha256 "bc04c1ee82f44fa9f6cc85df8e2a4efbeb66639426a2e751ac6a25f9f441bdfd" => :high_sierra
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
