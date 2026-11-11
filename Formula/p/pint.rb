class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "f069c1c34fc31950bf3fd2b89216c531ac750e92d19101e486e8ce7db51ca767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1419e988e166f241e44be97261c3757935dcfa1e485e2153c356ad31b620aed9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4072a7337b02c4f15bc31f93ad88579c22ccd7b4e14f65ff5a56566eca02d014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaa34c027dadf9c98d2b2d6891db07a6eeccc736106efb1d5a1cb68a773d7e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27d1fc2cedada18a7dbd433d32fe3eaca5e4d39a84594c1083eb7e398cade813"
    sha256 cellar: :any,                 x86_64_linux:      "2e5dc56be0e01d8916dfa9ff305eb45fd117af1165b7be4de5c4aeb1bd176fac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pint"

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
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
