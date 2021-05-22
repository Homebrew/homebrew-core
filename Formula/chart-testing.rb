class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.4.0",
      revision: "68a43ac09699ef9473266457e893a7ddd7ef6b5b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/helm/chart-testing.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "58111c64305e77677e4274eb1befabbbbd531b83f9eac4b1b039fc61c98d0e0c"
    sha256 cellar: :any_skip_relocation, catalina: "7e7c7511a1c3f67dd49f9a4f7a1e132ef742223b7e6393e2caa5537c34b4df36"
    sha256 cellar: :any_skip_relocation, mojave:   "c2f94bc1d9d58b6255a76af50139ccabd691846c847a7fd58c943ada70b91705"
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
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{Date.today}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"ct", "./ct/main.go"
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
