class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "700f9d5e290c02eafc738b7509e2eace196cb9577d50dc56e4b1dc43428a5b47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65e69b79231c493fe2157b11f61f07102294cd2884ce1de5e2e939761d44e129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "236790e27be53d5e364c208a23a03f9e98a8ec4d3f7b6159876bf09106d90800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98b622d029582b9dbc28b1c2b733fb50903fedcb4c3536b397fff82df12ae95"
    sha256 cellar: :any_skip_relocation, ventura:        "88cbb36bb125d55bea8d0e0a4d863ed4c6c9700da8977002c13e2ee0dcf715c2"
    sha256 cellar: :any_skip_relocation, monterey:       "0633d31f11ecf5fec3388cf2b88c8f58de8e7df2dae1045e5ae4f9a3a2e98a1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6de90b5776a3cd99a6cf19eb7c8066894a170fcfff266ec528ca88ab2215234f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b59f5b494db35f9af13c544580014cb2be2e76283bb6e8f95851c9bd97d4ad3"
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
