class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "b90a648c4881f8962ac0f46039db6007144fb2fdca85bfecf803f471c1fbcad3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4a17ce4600d14cc8d662733f18d9ef0d97003714395a0b4e6ecc53ec60e66b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8acd6457a4fca9d4bfcfba633413058b3cba0a47fb6cf3f0ae382c69fb37a75"
    sha256 cellar: :any_skip_relocation, monterey:       "a35c9dcc3d956c323653234cf40a01eabb454d9995da0266c7ee241e52d2f151"
    sha256 cellar: :any_skip_relocation, big_sur:        "c37159ee8b00601617ddb65e873090ba1acf45718fbf6976e4dfb3dcd2f23ed7"
    sha256 cellar: :any_skip_relocation, catalina:       "05d92069019ae96728a03529b017d111ae9de3995c624384d96cc2083e26a929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2621c172c71fa3a684ede900691038f7637b688b4111e36294dd5bbf3429cb19"
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
