class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https://grafana.github.io/grizzly/"
  url "https://github.com/grafana/grizzly/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7d8c461b8c56e617691f2062ba3a258ba239cbae6dddff7a34ccb9697c1421ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182ef9838cb68ca168c9310e04be2136c6c7920f95035f360e1fba2d01ae8116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182ef9838cb68ca168c9310e04be2136c6c7920f95035f360e1fba2d01ae8116"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "182ef9838cb68ca168c9310e04be2136c6c7920f95035f360e1fba2d01ae8116"
    sha256 cellar: :any_skip_relocation, sonoma:        "f071774226ab0138ab2154913f6c8e0bbe2bb8d4b68ed4293bfa0889a9703e15"
    sha256 cellar: :any_skip_relocation, ventura:       "f071774226ab0138ab2154913f6c8e0bbe2bb8d4b68ed4293bfa0889a9703e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc49d4991e6013fc69f02804527388c8fa88afdf38525dda02efa01fe52828b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/grafana/grizzly/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"grr"), "./cmd/grr"
  end

  test do
    sample_dashboard = testpath/"dashboard_simple.yaml"
    sample_dashboard.write <<~YAML
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
    YAML

    assert_match "prod-overview", shell_output("#{bin}/grr list #{sample_dashboard}")

    assert_match version.to_s, shell_output("#{bin}/grr --version 2>&1")
  end
end
