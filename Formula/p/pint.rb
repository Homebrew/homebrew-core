class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "c8ee91da7327d57e151f912c823d63e0fcf757b487ce6b77a2e1b83b23080ab1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c178179aed70b416566f1b4b21a5ecc9e8b042f0972776863deff9361ed56de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d47300c20bd12f42f65db75a0ecee63d74b4cb032daa389fb1136e523b9d834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "375bab7c2f4f3ceb72c6561476902804782050574474731237ddf74d6f8c925c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca78678021210837d445902694d63a2ceb428a3bc37d9be5a870fc9604be62f2"
    sha256 cellar: :any_skip_relocation, ventura:        "a347467eb13793f37439963d0e7cdbba0766cdbb890d2a440f22fdd7a78e0b16"
    sha256 cellar: :any_skip_relocation, monterey:       "b4575c943e1602b52d63251679c8eaf7bc5ccd43f5acf0c26fe2cd16ccd112fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e1efc7f9e56bf34ae22f215e29c136b92eb9c3f1c60d193a23b90e449a39722"
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
