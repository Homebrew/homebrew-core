class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.6.tar.gz"
  sha256 "c838908b202a690f88c6154d93cb1aac864917a299a4f6337c15e57947b86a79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96a0fd724bcbfde21d2a30fbd68c7c3c8b8d73581739485876a8087c3e9a157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43695c10d71bc3ddb5e399653e879ea3f266c9d133f35310cded16fb9edaa0c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6697f85bb37c654056bd6b70dcecbde14f2714ba6949ece4e6ccdbd6d3ca4223"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca80aa920633fe738854b958404232efda544b66e7fd1a33bf05193d8df3ef31"
    sha256 cellar: :any_skip_relocation, ventura:       "cdb3b637711cbf8700dda2098c259ee8a3a30f850716f103ffaa328c19265863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9ef42fe2822ef5072e5dcd005783b4473e46a5507ef24f24368c213d98df9b3"
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
