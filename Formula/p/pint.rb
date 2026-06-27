class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.86.0.tar.gz"
  sha256 "cfb717ed85015612876220d60e61eaf6760d6d419e98994aac38f8082eea0868"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e667c7cd075bb08090cc8d787bfcbeb1b03ed79fe741d3c1fc18233a7b9e253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43dbe6bf9581cd3df3943ff186b835ec270fe1ec64d65971fa8eb517ec715448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0276900f7859a3fcbb34d68ab5625d8048aa7e65e0e237d0f728f80b468f6b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ba18b42d688eff76eebadfac09a6623a429812903f640b6cbff04e3b8ea2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6673c7b5414c751d0791609de9fd30f52fe1939f1f25412ce1b60c342988b89"
    sha256 cellar: :any,                 x86_64_linux:  "416361dd42d8e8d78acb8164e04dce7a38b24efad52e53387891c920ddc234eb"
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
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
