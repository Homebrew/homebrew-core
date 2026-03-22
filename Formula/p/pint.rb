class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "20aed956388a1f64cfc363453e1adb0628e682fd176d7005667cf114953b40ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c820adbc3e9cecfa87f61c705798c65bb86e0b06fe6610a259225d7f5c80d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "839fa2b4ebe7b1a7d4a385e4d6310c8e54094f5c15aac323ecabaeb10fd8488a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9516686fb10f8f59f330a85a034058046d2eeaff93c906f92805898f2ca87e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e028e90e1f23ae9ad2160e805904b5a4006c879a6b6238f661d61d7bf014b91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fb9a7aed498d0c6b26bfe6f10f396180f7da2bb38fc13e2dc1e63a17a63372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5778d29a732c2f346039f8678c66adb07dfe4599ceda3403bbb7d11fc4939c5"
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
