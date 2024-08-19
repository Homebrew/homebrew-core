class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "0fa5a81e9706b520a27ef1493a4526f8983848caaa3526ffc8ec6edc2367de62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebf6988dfaf8ab37762d42632489cf39cc78d5971f25f3e1433427f6ce55c753"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2520add3f783ebb7eeb6b2e009da3fcd5dc2c2e5b37cb205a8d46b8e6b1efe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ce1d9a97b4f2ff84cc2d05a4dd8655a2dcb6e3a93a96114f10940baf576ddb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e055326a2ac3ed12f867b3ed3ed867c9d9c2fd228d2a253fad9bd98f2e4eed38"
    sha256 cellar: :any_skip_relocation, ventura:        "565ba15e204b55bd053531637498e5094b3053e23e06dc0e642a561d20d71004"
    sha256 cellar: :any_skip_relocation, monterey:       "7ffbf667a06fd88c10d374b00e1b248d9811130612b4657986aaf2259c66be27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89b8bd79bb39184577e3b7335da923f20e10b1bf419dda924eb55bfcae6a35e5"
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
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
