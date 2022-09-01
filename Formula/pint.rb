class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "927bc1a356178581ef1abad696430e1ee8801f7ce31e82f6da873c91b8467360"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66d9c4cb80ee58969b356acff6d72c9e3fff8ab9839c08a2604080aa3c3cf7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0003f7d65766b6b48bdc7e695c52fe2714b2e8e43745b4077cca244d3f18bf7"
    sha256 cellar: :any_skip_relocation, monterey:       "3b5f89829be8c7c99d4a4fbf7d728c7d402f47e677b7e3498f5a944c97911bf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd8699be836c118ab3a1beaef90c65ba8c8dade0ad218be04de335d6dc643210"
    sha256 cellar: :any_skip_relocation, catalina:       "470bf71d489ed1b19314c624ccbf29bf35fdba11122c3c88679accf6a445ba83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b072d4a59eb2f01cf6e3d7d80a13cd057720f7fb9a9425b28bcd59bb55828c"
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
