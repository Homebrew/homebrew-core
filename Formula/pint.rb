class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "9e6d5e8c1741c468b2c578701b7e9a3ff73e2648362f79793611e53bc77c150a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "851a3698a4ae69ab1d56af8e5d78ee390f42ccb6573e3d441f4565b39fff5aee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58a3cc6dc245674102eced2079cd832de34daaa833ce83c2628a143ff7a68868"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24a63963dcb142a6d33001ea22eb38e6e55b2f1667470bc41e5e89d2f15a2aa7"
    sha256 cellar: :any_skip_relocation, monterey:       "c50e0cf608846e1ebbc2d9eef99ccbb29bf901c0e1e26c662c3b49441b4a8c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e558d69c01c8052da4942ee22e98ce9593d989e5e8010a8085948e4bd9003d"
    sha256 cellar: :any_skip_relocation, catalina:       "b15adda2207f40cfc5a9ec0909554375d2c90c46c20708264c7e8c5fb4ee0382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc95dd83506df7014cc264bc60772f355f6f3270c817e971973a1aebc43e369"
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
