class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https://grafana.github.io/grizzly/"
  url "https://github.com/grafana/grizzly/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "4d05939982bbf6423373673b186a1e34d7ec2cdb9a9bce397b26d211b9867d6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6effb1fc86729013a53e2c215f6cb43422aba8dacc38f483956432f6caa4f36b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6effb1fc86729013a53e2c215f6cb43422aba8dacc38f483956432f6caa4f36b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6effb1fc86729013a53e2c215f6cb43422aba8dacc38f483956432f6caa4f36b"
    sha256 cellar: :any_skip_relocation, sonoma:        "436a297f6b8024a39c02e30b66c31a85322c30360dcf32bf57a8d7b912086599"
    sha256 cellar: :any_skip_relocation, ventura:       "436a297f6b8024a39c02e30b66c31a85322c30360dcf32bf57a8d7b912086599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4ad6540d603f8d6cac571b851decc400170ee3f58737c19fa2bd3795a2e62c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"grr"), "./cmd/grr"
  end

  test do
    sample_dashboard = testpath/"dashboard_simple.yaml"
    sample_dashboard.write <<~EOS
      apiVersion: grizzly.grafana.com/v1alpha1
      kind: Dashboard
      metadata:
        folder: sample
        name: prod-overview
      spec:
        schemaVersion: 17
        tags:
          - templated
        timezone: browser
        title: Production Overview
        uid: prod-overview
    EOS

    assert_match "prod-overview", shell_output("#{bin}/grr list #{sample_dashboard}")

    assert_match version.to_s, shell_output("#{bin}/grr --version 2>&1")
  end
end
