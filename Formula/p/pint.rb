class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "95caa9d9b7364ca7dd762071c3fe05353b74db1ba141c60f986fb19ab644b7b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bce0e1e965415692811d2e14e5d957105cff737277977c9c1f75706b2b5cbf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bce0e1e965415692811d2e14e5d957105cff737277977c9c1f75706b2b5cbf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bce0e1e965415692811d2e14e5d957105cff737277977c9c1f75706b2b5cbf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "97cec47755bc2836df1c3ee19bd2de5665e57cbe8aae98ba1a5a16dce492e112"
    sha256 cellar: :any_skip_relocation, ventura:       "97cec47755bc2836df1c3ee19bd2de5665e57cbe8aae98ba1a5a16dce492e112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3ae7cfa7f224fdc06225f5f8ce12bc4872de99e9dae34e252e5532a44ec9898"
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
    (testpath/"test.yaml").write <<~EOS
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
    EOS

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
