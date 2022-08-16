class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.28.6.tar.gz"
  sha256 "48b14fa9c1a961a7a1c763c97bcc085c6ac312f129a966d4c59c7fa21a6424c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509428cd71e83024b277fb786719c8a44dbce8dd9119ba62775d17eeb7b4f8db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f6c94e8a32b38a587f757dc5c9aea9de0f9f90a10fb0b4827d70d5a02088cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "df2ded40dc0ebcf16f76d3a64e569eed8deeee768c05f479fd1f4c632f618a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b936948e7ae4e9c71d8184fe3ab57ed1aaca47d27de64ae726e2b02e0cc11a7"
    sha256 cellar: :any_skip_relocation, catalina:       "086196aabb22c51d609a8c41293ae84134c8abd73018346a7bd2ded8e304b8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beea34a44ccdc97ddfcc0950da249bcd4ae845a8fd589aadaa1e3c7c5e30a675"
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
