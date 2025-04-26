class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "33431de4f75681b0ba2fb5134a4ae57be4012b336c49f69972e2ed423c22bd08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecd190761cc73a5424bd2bcd723d111610b53adb641ec884d4819277842a449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4106cd438f993d8081024d8fa86263c5ba0226e66d1919baf616c4144dc050e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef009c14dbe7f9728390ef82509fe156d27b6b44f7898aa73397e9d325cf1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ef8f199cbaac99888c078fedf8598555513b43661b054e8bf3e29b612c8307"
    sha256 cellar: :any_skip_relocation, ventura:       "05180df3ed82623d159e8e9b1a2c7a49fb9d9e97702e829fb207b31edb8750e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19952e31b693d0ddfed3842fc89d294c08adb9668ef24b031d89c9611fe1bb0"
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
    (testpath/"test.yaml").write <<~YAML
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
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
