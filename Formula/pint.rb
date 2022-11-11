class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "328db7f5f42511aedd388f69aba17e69b0a10a5d7ef8eee438de9195cc56cd1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0965022f77ecba3c8957868bce96482704c42d13d9cbd0ab8cb4a11dec4ef64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6558b8393ac58b8b8c0ad6b50d605dd3cc7a8836d91e54f17eb781d125832765"
    sha256 cellar: :any_skip_relocation, monterey:       "fb8ecbed1473acdd9ed2354327f0e87e9b21bfc1fae59e961b41d664d2196b26"
    sha256 cellar: :any_skip_relocation, big_sur:        "c45f92a50ec411ae75272d4f56ceea76b5b982c57e45e4986b9d0b9218ab4121"
    sha256 cellar: :any_skip_relocation, catalina:       "e9db3c5551a5d6676e97c67ee2319b91617c949d325ef2b358ba2646c0312072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b0f0b361ea337af8d693dd04e710b151685d222009c9d97f8a876c2e232f18"
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
