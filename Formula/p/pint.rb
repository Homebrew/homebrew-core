class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "a1d316986009df8aba5bccb2f7ff3fad63e3861ec28b0fac1f11c27f7b1124c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "215b2a03a9052ad43e2dca07bbef1a0ae5fe2cb02c230f506159cc8703ca4db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52bd6db32bbb1510c952150db501605e40032393d3eb6a0aa1c3f7976caec413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de04714d990265dd7c1cfd71676f1ad0c711e0b3c9e50ff3222631f3c0d4000"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c11154f398515fd7cf7ba4518eccf641d938693f50c1bd89c36778f63bc0c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d299ba8ed0de81f0478ead266f6f8393d22d568823459b702324918aa8e1643d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d67194be0097f2560a6758e46a750569d8f762fc12acdda724f555fe3bd96b51"
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
