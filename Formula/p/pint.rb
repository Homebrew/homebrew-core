class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.77.1.tar.gz"
  sha256 "9c4767dc347473a629b3e62cab8a469530245b48f4efecb7cf93af1766a2b197"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e5e4fcd4c1c861fb1cb0583a7bf37eb0ab391a06b41dbdf7858a0a26edd582d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "550df459436b350a0fa479bd56cd7f81b9365fedb8e8df941d200ffe9a7d862c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9a16a61250a6c7e2ed8a2247e6599dc37dd591cfde671c908251c95d8be6f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e027df543aeea9d47a27780d602b25f15e1c740b44cc0de6503cd4fd5446d3d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a7fe75c7e04f7167d195b99203f5cc1c8b137a6646246fa4aff184b5499e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e42ea70cc31388d9e9479e5fc30f7162bf84681257ef01f0987ff7c1c79a37ba"
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
