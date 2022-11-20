class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.7.1",
      revision: "f261a2809ace1dee3e597397c644082638786c64"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75100b8fd0d5cd10602a30931cbe131e4229a411a6bfc45e3f78ad3f063c20f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12a6169f8c276d9ed9eea8f5849ca232dabccaa9d3cc496931b226fa1e2da002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "317c065e19700b8edb723f68866847f4a5ff000f66e4e838006ad75f67a73fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "2dffdafc9d76294f0431cb577bdfbfab07bb1579d7d61cae0b4456f392063d55"
    sha256 cellar: :any_skip_relocation, monterey:       "eb013fc30598e97a1a1b94ed5e03feac1a76ae06697bb274e420bed5b0e6f0e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd8604927f5822fec4b08eb9e8cc95e82e9627683f9d2fb4db2372d65ab54b46"
    sha256 cellar: :any_skip_relocation, catalina:       "9a0f8350ab50eddf2e294d1711440c37f4a041beeb412935d273ee87d384dbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0466670cc36ce87349a679001ff59a379bfd9a76b55006f92084dab0f3f1a5f4"
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
