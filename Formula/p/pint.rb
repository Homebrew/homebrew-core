class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "a43c5a64efe709615d5125ae53f1a92550c1d8b16578490ca5846e5c392e0578"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0661ea9f14f09871cf56a8a615086a586db5998451129902345c7c2a50dc30ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfbc62ef546466f88ec2bb3acfe970cc6a6f30e5ab7c4c7caccbd5c313c0e59f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629751edffac646dbdb950e69225c59eb1b7d55921d30254cd2c4653a56329db"
    sha256 cellar: :any_skip_relocation, sonoma:         "23e934c2ce7404d387ccbbfbe242a9f49e4a63505f271856728e413b865c4633"
    sha256 cellar: :any_skip_relocation, ventura:        "799bf5323a8847dd013c9839931eaa27ca06b97ae75a44e7aa0d53adc110ef58"
    sha256 cellar: :any_skip_relocation, monterey:       "66aa787ef0e50c06f110fe20d33a2ae186c61bbc3473e5a24cf244bc9eff03eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bab285d6d88eee18723f74ed009cf86d80741b049967f11aecd738304e7716"
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
    assert_match "level=INFO msg=\"Problems found\" Warning=4", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
