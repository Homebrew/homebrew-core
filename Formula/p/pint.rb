class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.88.0.tar.gz"
  sha256 "19a428231123a402a65b06d7c9726e2f08427dc21b322772126c14467af7b2c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0ee20c5f8e084b432c539acd9e1ceb0840e56797654e883c49929a758337799"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11d8054a048e63945f9af347b6988353bbbf7d34121afd3e03d9c306d022cc86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36a06fc653109da394b29b46db5320a078d4e2e1f3df534b887253dc3fa85b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ced586e151a588de7d2e730970341750aa6c57361a62825f7ca3a9169e4bfd47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8cd7e9a8884fcbdc08f75359059c8318afe023ded8846fe4b8c9d6af71ac3931"
    sha256 cellar: :any,                 x86_64_linux:      "68b1f10446241c5317e6524dbca83fb4797fb5523d3a909f72c5e866d5a90d67"
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
