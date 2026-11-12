class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "f069c1c34fc31950bf3fd2b89216c531ac750e92d19101e486e8ce7db51ca767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7bd8cda77e23c38673c86802736cc640f86474d6c9f82a0c9c8385ae8925401d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22b5340040e08857d12ba3c8dba1e5e4ebe89f7264bbe1885444d4bfda4f4685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c90b2bb1adfb54e3d111fb82be6ee0bc5e633aab0cd8a416b2802af4e8b0b79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11b6aeb43168f5a1f241d30c0b86a6035efc4efdd9d742090b69749d87beb25d"
    sha256 cellar: :any,                 x86_64_linux:      "d5c7f5bc44e00cf89ef92c7c62755be7bd67ef59657cf5c98d11dd42b7f7b06a"
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
