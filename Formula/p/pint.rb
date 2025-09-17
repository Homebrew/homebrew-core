class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.74.8.tar.gz"
  sha256 "06c5376bf979ba3b516987d8b294cf0b1b4314301b64c0973571f1ef559ba323"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9fc8f0538f6bd40e400e3876fbdddf59e54c06649065ce8982234b7d8113679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355e4ee42f680db3eec2c90f0bd3da75a2d1c45be1d6eb395a746cb9909c5156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a0854625b911080931741b5a7e093177d451d46c6a2f637beb045eb8ebde26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7beb7d2882d2405256db722713b571e311e27f4cc79403352d6873843a7ef35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00763f73aab212492fa2b432830b05bb0eb87b0ebc5f882177387c3c0027319"
    sha256 cellar: :any_skip_relocation, ventura:       "76367275821bc293a7108b1e926e29716f599562abdb518dabd4cd981a0f20fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc7fe28d75620ee9bbd885a82574f86ff1fc69cee871dc5366e2196bf2453c1"
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
