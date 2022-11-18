class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "dc5215efa32314ffa1b993251d6d0cdaa5256d1bf638a48701112a09d538bf06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06fcc3a3199c9705f84c1fb88bc49946c02b14cf8004ea13bf54b46f6563ee74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e1e12dfa93d7879ce460e222242112d737bd656e289aa4a7d9188b55751bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af2509d98222dd4d5075a86a81602c38711bdc7a967b09a5d5790d1ffcece498"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc55b6e4fd0ef618cb38416234da88b3762f88485b67c2c8958b7e30bce63d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "69992d3474dc42ed561d84a09cc71b6c6af2a6423a2daee4a5f5c0c5e46e3849"
    sha256 cellar: :any_skip_relocation, catalina:       "e1a961a008e4a71fb4406718b7a16536bbfcf613f9b6255a147e7ac0dbfa37e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad7e2f88a2335e6ac54d4469451c2d2e578073d3c9994ea4a5fefce4daf35025"
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
