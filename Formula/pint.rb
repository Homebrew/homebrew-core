class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "286f8082dc9c75cc3bf61bb07f775a65e431d4cd8adffdabb715ea27571538ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd439a027527b8d054b587851dc18d790d24ce9a92d6168e3cf335499ae7232a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e77313bfef118446d98bb065eb1f8eba2f4100665bb250634bbc7c7db148f8bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd7f18344e624f25e5a928b3d0e63b944231bccbd3f329baa455f986f6919dc7"
    sha256 cellar: :any_skip_relocation, ventura:        "e572c0bb679b125b902a00604410394325b2e1e8325c70ace16a9844f3ff322a"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc62eb788f40f5c57c7dcc2bcf52f6e09208882a69e247f031aeddc6cbd62d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "124ebd77d9c0a72b4e4a685dcb6496c6a37dd1d3115de7a72288c2c4c7ae351b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbfe31c6056789e0ba72823787eccecc755ebe02e27e848d41797272272901fb"
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
