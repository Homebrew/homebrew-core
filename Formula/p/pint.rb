class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "30dd3ab7ac0b78b06f1cdcb190f4ad3c447cd95ccc7a8a32d244df95a76aef97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8718260b04c1b98dc0c08a06791c1443a44a264bf95adeaed9462c94a9b2649"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1672165d759ffa8ee78486a32f0e25648495d43ebcaa70f631fa7c778951f48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8474f908b57604780895c5bfc0eed2572775714a322a501b34bcbd5d13f1e665"
    sha256 cellar: :any_skip_relocation, sonoma:         "fef896572edf62a6b7ad3ad803005b076b4b62671eeff0086238f056409c9d09"
    sha256 cellar: :any_skip_relocation, ventura:        "764c8837a0dad95f336704cb4d3f8dcdb817cd5f7b2c1d741362979a0997492a"
    sha256 cellar: :any_skip_relocation, monterey:       "daf443456ab528dc5379760b80b199ad28cdb8054920fbf2e0f1e550ddcae2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc8a3f3509d4fc028ba8b2f1402554a3fbff6d1a791b2000da7b16c30574d52"
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
