class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "5faf1a0b8a13f1ed4754aa9fa45249de228bf2cc2cc6ab833076a34c42796bc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c864432816c4345bcb003e0e99e2078533deff238e5bb79109eca4f60ac577d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc45c1e6ba23a773e0794b59742c10596dc2b6a6e1a9a22024819368e71fd20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14298e900ac1428b2f47c956040547d7d7cf8657fdbb2c64737fb364bf784bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "30168d1156f38e51c82e61f625475b0a1c105e03d3058dfe244fcfb26f5299ba"
    sha256 cellar: :any_skip_relocation, ventura:        "509dcf4792bfb0a976468bd070aa30443bfa0fcee37b65036dd345920f6a705e"
    sha256 cellar: :any_skip_relocation, monterey:       "2419f8b03e9b7382d2b4c4a2287151243cbc63c6db359850da094de9d6784f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4bc9d7a14eabf4da48c78596a04bba030da8ccf3fa09ef7ae21b37e24d4c85b"
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
