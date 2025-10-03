class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "c86de12ed070f00d88347911001a063f7ebcefe563d1dfc69f7d4d3ea01c6975"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b77db748bd3323ff6d685d571fba5c2ca19988375eae78ae9b2f64fe47c819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3997e8815182439b2ffb88209632e9fdc959c1d44ab4e4f80602611ed0c68d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "517b9d81f7f9211ca28841b9da09f2c5516beb615f612cb79e0883610cbfcb9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1c3a738e3ea55930575b1ddea7732530487800d9867f5047902f062ac6f811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874ea02645fac96f66a20aab54ee5347fa15ad225c25a239206012fcfc6f6035"
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
