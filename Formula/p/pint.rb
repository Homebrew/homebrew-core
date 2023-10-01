class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "5cf9583e8d1494084981355df3555b599c96a201ce223130f57b50623e60d4cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d525c939ce0fdfbefe6a8d2ea4ee119715fc065280271036e89c0fd859d674d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5318e5751cdaa884e8cb0046a4408865fc46547200a729119993f250807df1db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "992b13835eaa39b62e13b8f6cf76f705ea9d88d44153342c726e82e27dfcb5d5"
    sha256 cellar: :any_skip_relocation, ventura:        "154795488f9627ace027a3ab430ae3a6a53e6faf8dff22f62cbf6b91483eced2"
    sha256 cellar: :any_skip_relocation, monterey:       "15479b6ba6b2a2795653c2a245df73c647a158143123999329be8f0a8431e7dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f6da67e5240ed517802efac557085109273f67e0d76c4cfff2f51d9b6245d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f971433277c55555e915201b03225082cb052335966799f2617ff57106e37b4"
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
