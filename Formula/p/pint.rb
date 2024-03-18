class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "1a38ff41a08961fa3311ac55bf6400ee3e6eb5974fa034b027e2c5b9e670a47a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7d4e2b34e2a7489bc3f5bf35127f7535ce291e8136c895773797e69a3a922ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f5acf0f19d2ecb61e72593217aea7c6cbb42e07c906a7dfc3f3ff32d40a7a7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6965192cf14036dc44b60ca4dff7149744c21fcebbd2de58c84a4e04ac19176a"
    sha256 cellar: :any_skip_relocation, sonoma:         "169db5d0ecde8e7e44092be2cb3111e2cd3b52193e58e6d98eb9340fec3cdd6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a209e45e3342a4ace375ce11debb4bfc6f1704b80e5dee25b294fd79dd80ce9"
    sha256 cellar: :any_skip_relocation, monterey:       "47bb1077e039fe1343c34f31da6f341be697e46e00ef1c236f3a473695049463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f8cb447e35761edf556f2666ca96dd193418d9b446b3a838afa90bb121bdd3"
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
