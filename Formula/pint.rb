class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "276d3b215ef6f92e04ac8ce1b2d43e28a2ed4742829573f169e8ed6c61166976"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1b8586e5d47efb9e98bc132579ec1ce8a6da58ed39a32077594898aa026092d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe05a4fc67039f606851a8cb1478c62fafbaf1a421057cdd436abf9c7079359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d3fc4b1acab924ca34a01dff454098179f4097d5724f4cc5243b329b1c9434b"
    sha256 cellar: :any_skip_relocation, ventura:        "cabbe432c1091d146146baf87d1cf3f4eed7bfc762a1dc2154e72b9626c5aad0"
    sha256 cellar: :any_skip_relocation, monterey:       "5d96491f11da0a5eea8d75bcafa52b2eaee346f8da7afc99c4f1fece52a20fec"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d7a7bf375e8811380f112f89e79d33eb7754f70474ad6907e7ef61f6d6491c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac7013df0a20cdedb8a9bb4c7928b8128cf5277edf3d382b4e2c6ab7e94437d"
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
