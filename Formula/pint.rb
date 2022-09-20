class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "f38377a2c70e118e2a75dad58446e44142d03776bb48e476747d548e17d1365d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95302986f3602982032fe1eafbbc117ca3439566b1dc08da514e99fca956290e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c239e1517e451bd5a134f596044fff20df4c16dc7b0acc451314aefc3b7a395b"
    sha256 cellar: :any_skip_relocation, monterey:       "7117de362c621fce4064bfcf3cb96c4e12c70ebd594f4d0a06e815b72248bdf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0845db20c33d574a103951ca15f542d0f798c7192aba006154a81e64a78a05fc"
    sha256 cellar: :any_skip_relocation, catalina:       "2c1db0358525d1647cda1e3f21adbce640be12346576ceff4fa4c07575451bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322e1445476ff88c80e1f7377e5abaed64017a44e4eb5f69f3f1e6a1f549c3bb"
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
