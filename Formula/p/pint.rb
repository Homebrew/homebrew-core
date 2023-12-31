class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "6bc852dd64387a7ff708d3e0262656090536ca8e58fdc27e8705a15043458077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a036df8d5de6124d67485669c1c9a8b72e3e88220463ed892ba3521d383c30d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cace081c0c89537298a1153f639de82e83775dbbbf871ae32a98cbdf8a27d250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de01c8320ba48871aca4c0ee1f041ce0000533b9226e1c88ef74175f4932c5f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc9fdf68a8ae93a022a75fed61fc8f2ea28abdc39d80454c2f71ff88636d88e2"
    sha256 cellar: :any_skip_relocation, ventura:        "fd86dfc903d9935c66b8feb9b0bafddd8bedd1e2ac1c10751a3fbdd1c47cd6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "333185bcc741d6cebb24a32d4b35b6163a496d8621bd3a6efbfff049ee7cd6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546260e12c7a04c0309a5f40de349bbf2953cb04cb412e902f8b12671ad59227"
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
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=4", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
