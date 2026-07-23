class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "ec1cfe7e458d61bce0efe8e11c65c137be933d64c7a857e6134ce1af70478c2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fdb289960b0fba196a9854313acfa1cdd92fdd0528114669c5a8cbecd199e16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba91c91f82a3be20568600b42e851131f5109146c2ce200f40cc57397624d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92f20f354ec3578691c63534b38ac55f295ca9e55f9000e1190d9c778cbf4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f73d7260dcac560acc01b7b569406a7ed39195d5cb2106ee9bf4c0b96a0bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6567b8038131bb0a0edf84693cee4277b85462a88cc73a5e3632c470d32c6501"
    sha256 cellar: :any,                 x86_64_linux:  "fe3a2791e29da24a6d8d70f22bea2b868bed39eb0550005ca60dd5c1472e6457"
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
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
