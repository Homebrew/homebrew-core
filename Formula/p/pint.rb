class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.74.4.tar.gz"
  sha256 "cd7dec28874a96de74ba04502ff32dc7d5208d0a0fb999ca34a8353962034ef2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39babf55d2d368ff5841ec93a44fbdd4450c77bb2ef8e5497e47a09ad2d77c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fac9cfb3175de44c69e5b8c4edef5af4ac8d213ed3785a3f971fb8a5389f271"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "affc80a92ac7f4bb0d7ed39ed313a146e664e9f281e82d3eece67b611ed9674f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9433d82f70f318c25e3e809468962e5b7f2659be66e3d50aa7794559808f4bca"
    sha256 cellar: :any_skip_relocation, ventura:       "5d08e724f198867077552398b8b03938d0f48e47c2d247e1edb8719a1e742243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3ab0eb49b81e972dd5f29bc2e5d320028f391091d843949732c2c6202f492f"
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
