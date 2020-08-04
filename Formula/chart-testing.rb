class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.0.0",
      revision: "50db473a1e68c605b18d82f019d83ea401542213"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "df4d2c0adac9176896955b1d82b5b8351a4f4f9b1763c9809262dace250c0a66" => :catalina
    sha256 "3f63d2b0db943e7ead94fb917c4ad99e8b97a445f8ded3676ec812a0895a9e9c" => :mojave
    sha256 "d6438baad2e1ab132d22a42480254870532854eff59f57aa54c900c03e3bd33a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -X github.com/helm/chart-testing/v3/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v3/ct/cmd.GitCommit=#{commit}
      -X github.com/helm/chart-testing/v3/ct/cmd.BuildDate=#{Date.today}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"ct", "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
