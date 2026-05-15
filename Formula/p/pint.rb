class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.82.3.tar.gz"
  sha256 "4468f075bfecd16bbbe7685786b39acce007ca044d18b3deaba3fac1f60a4486"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "772e87ddf5bf1967c85d4dd52f531df3924cb81c639b7036b16894296eac1a8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac1ab2722a0fdcfd96a3ddd1ee53654a334c8deee871ddf4b49b68e36face693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a278e406a9dbd12c48c957426660a88b36f3c3cc64f4bc3d031b468f931f98f"
    sha256 cellar: :any_skip_relocation, sonoma:        "425e8eafa105ca9176c42f8da172674fe23d2bdf28d3d7411f421d8367ab3607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5be25b4fe9c3170b4564858746362fd5e300454e0e4909b31a24e2f8b3277fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0a27dc96b90bb9793f152e8ca8cea4b73ef3aa02a2f6cde501c9b9291ad9e6"
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
