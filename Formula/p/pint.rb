class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.71.8.tar.gz"
  sha256 "d2963305d3784b85fd843f92d6b64cf0d3fa5e3570968e6d6e4aba0afffb0c12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b2e03c8874ff397d51fdd53452104950156d1f3d5ef789a76720dc8db870b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0079a0fcbb734445335ff8ade348e615afb62f7ef797864d0a4202159a71680"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc9b8f1d8ea35806e9bc9af69879f94916eaf2b799aca22dd35873b69d10d04c"
    sha256 cellar: :any_skip_relocation, sonoma:        "be34579a94b47e00ce29bb0af95d49494a38334590c2343caff989f7ea92e300"
    sha256 cellar: :any_skip_relocation, ventura:       "5583bd0ea677ed1acdf618c9bdacfd8862f6b6b5a05c0151a43d90830c3496f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a0ded4a982962e03acb04319324d99006f8ac9df5ab997b7e7f21808ad799a"
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
