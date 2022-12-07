class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "9d0bdc07e254b729d1ebad29207f4469d7bf92e93c68a3f919b97eee832caf82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31de04c1c7c9ce2294536ec5c5a654c4b8a03ac398c6c5a2e62ebba382aeb14c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3f711f0669319616ea44df795d33489a01036fc643096cb7848b4c47540e82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba38e1e01793277a4aacade379e5f64a1cc6ad47b1d86781afe9f52383967ee3"
    sha256 cellar: :any_skip_relocation, ventura:        "1ae7bb598c532c23ff2ab58e4235e920ed995ed007fb3bb50c2ce9dae0ff6087"
    sha256 cellar: :any_skip_relocation, monterey:       "519972598e47cfd4c023742e17bdf2b13b88133a7c5c66ae89728674a25c3fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0dd2fec16a92f466e8affa5c4ec16484269b3fe4e3515af8f7075569384685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb11c154f80fcf565b1e34594047990d4cd7c65e1f99a1bcaaf33f1c5551996"
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
