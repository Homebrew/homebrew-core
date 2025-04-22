class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "9d27670a44015882da9af41c7768283550676d97e44af3290f7bdf2ba14bdea3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a88c4c23c7ef87e1c7e10f438385e574a7e9a4b063f3bbbcb66effab1a78f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c23406b4a188ced0fb573394c36516f22de62dbee872994e82476cc4c541953d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5128a0740df77098283b859a9bca4d6e82ff4624da530363732c5006a279b39"
    sha256 cellar: :any_skip_relocation, sonoma:        "be33aa58d8f8b3df93263efbf91c39a55e41307ca013d0a63b17fe92ea1be4fd"
    sha256 cellar: :any_skip_relocation, ventura:       "bf5082a84f09cffa35461e7f9a4f22f779bc6fd0c6bf4e7f2243d8f5198c3c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae8d402ca3d041e1d1aa2d0658cfec7eb8211e2f8ed99dfeb56b2c5ae4c6ebe"
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
