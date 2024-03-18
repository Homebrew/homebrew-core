class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "1a38ff41a08961fa3311ac55bf6400ee3e6eb5974fa034b027e2c5b9e670a47a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4dd597d0f78bb86192834593f51d4ebcd9ecdbb2a19226594a3ac10fd86bcf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20335e41096f6ea012ccb7a7ffb3e2ccff667edfec2cb35191b7882fbed282cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd4fb942007bdd31e1a7c8a7821e8c3620764c28cd5242af9064a6053e2d643c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d062697a3dd2ee4f80509060ed91733ec86a5cf6d643a7a6a54b3b7684f729cd"
    sha256 cellar: :any_skip_relocation, ventura:        "215fdb423a231dc5fd02bf12f399de6b993986d74d766086b2ec62e6d74db7b8"
    sha256 cellar: :any_skip_relocation, monterey:       "5c86ed16fca50a55d618f1fcaaa8a4a13b8ca0acd51920a6be75a52862baa726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f6c0649c212d5285629cffbf6d1c18e3341ff955018ff4ad6d9c30a89800da"
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
