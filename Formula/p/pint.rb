class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "bf5e71afdbfa823bc1df303d0078e93310401e79f2c4aff8f9da5c8812209850"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1226f5ae626efe6eadb251f382b46098fefc66f8261bad215bb4c0cfb56a9524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1226f5ae626efe6eadb251f382b46098fefc66f8261bad215bb4c0cfb56a9524"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1226f5ae626efe6eadb251f382b46098fefc66f8261bad215bb4c0cfb56a9524"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d44869856be8aa9c993347461348011b59d7ec2d5376ae4c373fd2b96ed05d"
    sha256 cellar: :any_skip_relocation, ventura:       "65d44869856be8aa9c993347461348011b59d7ec2d5376ae4c373fd2b96ed05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4caf21e2ffeff7dbe9c274ce8ab49009d1d3ff2434f674bf4a0b5c4bb48f204e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
