class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "cf57fddc42df64d077082f04b2d439dc204a2d012e30bc74a18383c24d31d0ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c813f04ef1878e149bedbce55e9840220bb3a562e787f8f3cbd758e53eaf18d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0d3b10fa52e77332998da184bf40b270ae8692cf73c866cf51080bdb295a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a9c2fffb7678f16325c830e6af280f2c70b6ed5b2899d5d9b3bb95e6c3925c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e066803b56b162c926ceb857a0ad977a34e5e12b919c386a267c2d10934dc23b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c19ae9711e1428de5f8a15e35ebf6fbcc6ceb56297f4bb16dd1b9009b5b4a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e5c7afbf883f0d5be49104394883fe269d501e5b51dcf49c396e50b7cd5784"
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
