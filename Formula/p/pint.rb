class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.7.tar.gz"
  sha256 "ff8d76227565a033fa50a8f3079ef5dd6e73c8ae0cd1ba07ea07f035f8b6e97d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96dd76817477cb396e8677ecae3bc1eef77a926102af6c0df90886b8ae83e156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29676dab7ee25a6fb45f376cdf2ede1f82926cb4d22225bf880ce83761ef5bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "382fb3a948c08a9aae51b562f9c3d7effdd9ba0eac2de15481fc15860757dac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3010f7d2e734839d15be0b4e113f4e4e17b74d5c7dd144dd5a448e11f5dcb22a"
    sha256 cellar: :any_skip_relocation, ventura:       "e32b2c1c8c588ddf33dcdfc0bfdc04801a1e814305b56b684d1efab55d67af61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6109cebebda26ffc63d5d63acbdf9b34c9ccdce168bdd8d1839d60aed253a5"
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
