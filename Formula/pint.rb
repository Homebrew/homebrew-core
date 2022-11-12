class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "328db7f5f42511aedd388f69aba17e69b0a10a5d7ef8eee438de9195cc56cd1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144793b4f9074292a2c5fdca3edf1029713fe5992e90fc217cafcb24991863e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5be58e470e3c2204d7768c42ff413790456938843fc201d34f79805387d2ca54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbe667d3cc8ed60db661dbc487b4d4fd5884f209c88fa9265769a43d56898732"
    sha256 cellar: :any_skip_relocation, monterey:       "03149ca3fd899fb6fe71a9bb9ca64e3cb22f0520ae7b79fa46e3523411146855"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0f707f85d2d0b2705bb03731bb84a6b5c263c77b843e1c9ef428ec98b2fd1e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c165f1ebde90081af4acac82b60657067da0ea74092211a74c4249beeeb85c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9890610d52fa35842a95d30c84edc268fa71c1fb8f3c39809bde057e0694c76c"
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
