class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "8a9b9eb9bc35a51b74f86a2274b9d3f1ae2090bddce8792ce1287782df7b5ac2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31bf500038088106bfda134efe9f786eceec7c465c067a6f406022bb68a7bc2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f21d5fc080c1eb2921d8397aad84c8577c763c39de71733b3a30566ce6c76b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97d5262ed745595cba72a922cf5bb20c9770d8b624987c837983558c25a148e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f05a7e825db1dea6e8af5429fb19d6250d08d5d1e162eb86408013f5100e5cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550a56d5abe3bea43dbb4a5d59e59753370e3fc064583a04366f4d3600c04011"
    sha256 cellar: :any,                 x86_64_linux:  "85c9d99e5372206acf26f1e624aec2b0d868e16a6c01e74c472657686704ab18"
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
