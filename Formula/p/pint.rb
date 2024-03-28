class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "6d245ce3583f9ca5c149099296061a0284816bc11572fa4befcc70b4f0fac791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d522f1b301094bb0476a01ae5676e3a47f66ceb6677ba6847460eb752acae9b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e75e359c536a46eee6792900be134bcc40cd09f0708ab74cdcd10b23f040df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5326d29e85e40d7cebdf166ad05730177309cb057a21525761e6392739854f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "977c78f65728d98f85f90759bba007672f21464920993e6f488b858282613ee5"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb1f921a83b5fe777ebc9b4d2d662d231613d414b086c3d2fcbcb441a4640ce"
    sha256 cellar: :any_skip_relocation, monterey:       "98261b12cf5865cf5c6213e73af182d4387a8289032414128cd7c21fbe19da91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e5c9dc623c6efa6e249204f7985a486bc75a7d6afd8d2526bab5442d1062eb"
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
