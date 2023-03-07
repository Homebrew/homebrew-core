class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "8c25b5557a8e207da7aa73f259c94dadd15784364e41b71c2fd362801bb8c168"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd5ad6b54d3a2c66daa6a2a7f1537e9ec2f4bf462a9f03d8340cb9e02f0a1fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a58da6442c03bf0b10909dc05387de1913b284f36f730dac1c28784a5d1d54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33211ee0f51d8b12fd5f0932191eaf15c0941c50eaa0fbce6403a9415155f02"
    sha256 cellar: :any_skip_relocation, ventura:        "05134214be06da1e64d42267259718c0e4b34f46056b7299f37df2fc1277cbbe"
    sha256 cellar: :any_skip_relocation, monterey:       "189b15a2acc74723b70e3b920e9e46fa125a2f59fd1de1b9e0ee9e836ecc7b9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5767c2a601b155edc857733bcaeb2f77b41e9004f18d1ca5c96b29fca0cc86ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933d4a7ea652f7ac04972ed1b355ddaabd1267b76269d543fd51309de13f9066"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"

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
    assert_match "level=info msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=info msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
