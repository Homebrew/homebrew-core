class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e8a2cfd87910162d8bac4d56572b11db112c8f1f9ac9df583a1bdea5c4ec310b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a25f0585c4bad2c5cf202d42073cc3be27a12aa82ab0b17f3566a08e6971d07d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c2f382763e1407467e566c0e83be1b59b126801ad7bdb88656b5aeced8f46aa"
    sha256 cellar: :any_skip_relocation, monterey:       "749bc148e5ca5b43ba04e06ffdcf5a14637c07a352c54e1f06e092e45f464c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "abd99c3c597238dc712857ffb37952b6b9955959642d4e5d36b4dc15fd2ad12d"
    sha256 cellar: :any_skip_relocation, catalina:       "b32443fe23dc9c0a840225a98e2c9bf4916eee59180f91326154551f1d728695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a89018d6918cc330eead647fcf8ba69ab646fa5ddad9003d00f1788478968ef0"
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
