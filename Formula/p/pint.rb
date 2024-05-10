class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "35730442f4e38ab92f2f5dd98413a1a32e88b0a11bdee349e634bcc2509d32b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1263f7f67102591f7fb36e1f03613abae775152c0f7934fd79dfa76e1a994f76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2976ac8fcf80a0d477daf584f485932914a11a809164bd502638d813a0b6404c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d304aaa1696d3c4fde4e0098d77810fd74f13d99630d4541fcac99bc3dea896d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e056e05fcf0bed4ebbbc15f4eac109ee3911836e0c01ec37ef6510f518f1462b"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9b1c37d29ff3c10268ff9e90afe592b3f2d994674d558294a7820cc660ecad"
    sha256 cellar: :any_skip_relocation, monterey:       "ee44d4fd31200c623f34fe8869996d1583c872c99865d2be441a5410025b13f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499a1b4901ab08892d0f68acbd2abb5d16ab1e937e49acc98591800e04e62217"
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
