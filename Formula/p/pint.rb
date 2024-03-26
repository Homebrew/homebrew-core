class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "5faf1a0b8a13f1ed4754aa9fa45249de228bf2cc2cc6ab833076a34c42796bc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91619107131ab05dd620970eac4d9abcd06e2cead56354ddba03f85624a12a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6119c17e35175fdc1c240e22028736ea72163016a1ff3c2aea374977d27015f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b6055a827d645dab3ffb113b843de6df0fe51c4d66bc96d2e7efd1269c8ba58"
    sha256 cellar: :any_skip_relocation, sonoma:         "81eb52ee6b062016a8a9016b01aa0ba1be0c38abbd1f1a6179c9953bc12fdc5d"
    sha256 cellar: :any_skip_relocation, ventura:        "d780e4d8ab072fe5e96873c0b413cb3607c68bf28ffc520217dd52767f52866f"
    sha256 cellar: :any_skip_relocation, monterey:       "e8e11396866b2ae7c34d101544180bcd1ec19f019052b2a3fe09e46bd5e28ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa822f71393762bc6ab5c858271e58d132bf55957f95ab2b3430107f23e5d00d"
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
