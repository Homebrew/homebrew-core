class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "3cf4a2bb782d0518f0a2d3d3da350f2aac65213cf83c981b475f436f1fa47ab4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4e765b2da5ae0383087208f1da4554b232960f8c8bbbcfe5f6cc4cfb68f2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4e765b2da5ae0383087208f1da4554b232960f8c8bbbcfe5f6cc4cfb68f2f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c4e765b2da5ae0383087208f1da4554b232960f8c8bbbcfe5f6cc4cfb68f2f7"
    sha256 cellar: :any_skip_relocation, ventura:        "31606967c7b9d6ecc4f5b17cef66b11a06425418e9590ce6b2d2dfbbd4ef729d"
    sha256 cellar: :any_skip_relocation, monterey:       "31606967c7b9d6ecc4f5b17cef66b11a06425418e9590ce6b2d2dfbbd4ef729d"
    sha256 cellar: :any_skip_relocation, big_sur:        "31606967c7b9d6ecc4f5b17cef66b11a06425418e9590ce6b2d2dfbbd4ef729d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4964ef7cc2f30cf563422580d43191cd0ef26d187f42d8dfe345b4dbfe6c8f5"
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
