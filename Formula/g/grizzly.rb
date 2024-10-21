class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https://grafana.github.io/grizzly/"
  url "https://github.com/grafana/grizzly/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d2a90e702d77bb0ac9e5a995d24650ad3510cc01f1a96b9a5cef51f35942dd2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbae00810ecdad4fd3d2902309fde77c33f45866802abbe8c536c7270fabc60d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbae00810ecdad4fd3d2902309fde77c33f45866802abbe8c536c7270fabc60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbae00810ecdad4fd3d2902309fde77c33f45866802abbe8c536c7270fabc60d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e0e87d34c94f83ee3211c857af91b61e49f8a49fb3a25789befe6c41f3d32bf"
    sha256 cellar: :any_skip_relocation, ventura:       "1e0e87d34c94f83ee3211c857af91b61e49f8a49fb3a25789befe6c41f3d32bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e1cb3f2a3b65ea00731a50e7cd00b2d19a379db3f5e3429ca71f0f161bf7d6"
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
