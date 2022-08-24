class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "5be7170ffa60590c470c79d416cf93fd2a0d04351f2a0be2caaa8f45e10a0203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "102da9bfead7a7415a339dd7fa70a2ccc9796edb4ab2022c63e1d10aaab1c7b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9200f1dae9dc7faf6d975ef072a5fccaa98324ac40eec0a793e32a03237f25a"
    sha256 cellar: :any_skip_relocation, monterey:       "c1dc6992e7cf2981ddd1012ec1f8322aba1fe3a9dfd4df301ecea10542e0007c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfd33af988b132775285821c54af5212aa96e4c4a9cba05e39a0060ba2842e24"
    sha256 cellar: :any_skip_relocation, catalina:       "a3eb479aafd52af37335030a9bbb6fe20874f1137106f53e666f197d2b97f36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5630b569d23e72f241bea841aceb36093bdd15c2dc165c08b40304f1aab565"
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
