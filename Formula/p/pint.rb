class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.81.1.tar.gz"
  sha256 "81daa0fd8cfb958980e8af84f5546be44a7624335879fd88ce1f6be27add1f14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130c062e1f5efdc3bce4013d743400a93c3f3fe384b3b41c47729fbe71c9623c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d543d817cac22def8d2adf83953e0a1cfae9b8d116487bc77b1988a95d37ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e864acfa2fad5f60361f616b927411de03212d1a763827fdf6735cf86a65656"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9fc770288b0c1ad5ab18bce0d8b0f71fc6565d902a83664f24445032a0e402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b83c88f1ecc4582f5795aba5082b08abeec45264ce303ff74bec289af28da49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b69d4e27b47a4d25e1cf569f69e21e7dcd86c8dcc1c740f7cc0e9b820e61057"
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
