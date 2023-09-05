class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "5c9e97ec98f3fbd4b610d96ea072756eb9cee6199207e96ced25387078010bd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc3dd466528d788daf3909092ee7cf89094529043e4a86d48c1ba1764663aac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc3dd466528d788daf3909092ee7cf89094529043e4a86d48c1ba1764663aac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc3dd466528d788daf3909092ee7cf89094529043e4a86d48c1ba1764663aac"
    sha256 cellar: :any_skip_relocation, ventura:        "ee4c9849ddddc03c418b4a93cc4516fa41e3cc6d687997286d33c123272a89ea"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4c9849ddddc03c418b4a93cc4516fa41e3cc6d687997286d33c123272a89ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee4c9849ddddc03c418b4a93cc4516fa41e3cc6d687997286d33c123272a89ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3defdb3654d9054802f8eee4d175337918cf3320a06fc444696cf335fdce1b6"
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
