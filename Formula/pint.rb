class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "2124afc6fee385c12ac754ee66ac6e27fb7792e1d0fa24643c5502990bf1bf57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecccee53199b2d8cd5b97caec7e05ebfdb44e961e88d507d41e01cffd3f4c7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84ad85eaf111414be900783aaacff83dea01fc4db05538192095a7abdff24c86"
    sha256 cellar: :any_skip_relocation, monterey:       "11d87f230a2ae703b2c3254d4b2136fd048e716e54447c520f20f997f117e413"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8b149fe24019435db5c9253346f8c4eac864cdd9cc129d8327390f9de905331"
    sha256 cellar: :any_skip_relocation, catalina:       "a172acf162e08813400daf980e41c7d6c601f38292b53990ce8440d100b40ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad08d7a20491a903fc2a1e2a1e8e87e6a91b3fce16079e5a7d3e1682879598a"
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
