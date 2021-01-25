class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.3.1",
      revision: "71d0e1e82c5c8b66ce4d9704426dc13b7075829d"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eafbb9e075ec41b2ea96b341173a286be38928eac51dc8b24796c45ace00a6a1" => :big_sur
    sha256 "fedd5373948e1ddd30e95f903a29d7173f069660ec4b0bed91f7ce8bf9d3ef40" => :catalina
    sha256 "ef933f0c425753b905cee3d9a66be61e58c1bf4e31fca67b2ade2daed2a1642a" => :mojave
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

  def install
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{Utils.git_head}
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
