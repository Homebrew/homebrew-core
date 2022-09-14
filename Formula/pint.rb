class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "b052528787489ce59983a01d7a061698689f0131d859fc521fef553a3c25ff55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb08baed0ecdb74201f05e0a54fda7e5699340ad42e64932739a6a301cc98cf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8d1c2bdfe5c6ec07e1c27fe1b97fca1ccbfd8de4168638105ece784e96098ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b0bb44771b4a43168eb1e64f10af532f9884ae40d70099252bd0b06de3b3be5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "081710f361b03c6dd1a0a6ac92b64298da52371553198f5d831bbdcb43fdaab4"
    sha256 cellar: :any_skip_relocation, catalina:       "bb0c65b05063fd2d66f3637f2624978d32b4352a0aaf73dd698c9fe0b797775e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a72b9412835d6d1bc54fe76e461cdf9b755b4cb4035a3200516fff9d1e2283"
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
