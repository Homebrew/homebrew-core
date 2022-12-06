class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "7df60e20fa4bdadfca090b720b69b653c188d2fb787735084f6b1a5a5bbb8470"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d945da8171c7b3eff1740c98179643f62cf30b68c8d48539c2e9c6b20a08e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28dcb2dc3f557ec34df3c0b2bbf57dc330b2976086e2a46860e8390aa612b928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82fd18192740b83947f40b66144e831472043374f6bcece1058eb7b9831a0189"
    sha256 cellar: :any_skip_relocation, ventura:        "f1de2a48a955bc3e57548a2fffddbfb06fc871a34c63f527808f30335e3071a8"
    sha256 cellar: :any_skip_relocation, monterey:       "70c023e65c934fcec6f648f5f43cf859fffb18e2de7586c680092c4f74a4a596"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e33362c81472f9eb3fbde613227f6b76284178342e97ae0f6c0eff71cb8b8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe19e585e6016fa48cbdedef3fdbee418e284c26a6f1b202d113fce012af82d"
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
