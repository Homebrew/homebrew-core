class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "0c47a42578a9db8b4ce455c8ec7b94f5eea0f79752d60e119d0cc6f24b43e1f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7152134e52af0ab7ca0381f247fb7249316640068797b3bccdf6b07b9f0fa51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7152134e52af0ab7ca0381f247fb7249316640068797b3bccdf6b07b9f0fa51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7152134e52af0ab7ca0381f247fb7249316640068797b3bccdf6b07b9f0fa51"
    sha256 cellar: :any_skip_relocation, ventura:        "a9600a3694fb2ddfd9853ad13bbca3d086e3179879486b8377700c6940d6e8b6"
    sha256 cellar: :any_skip_relocation, monterey:       "a9600a3694fb2ddfd9853ad13bbca3d086e3179879486b8377700c6940d6e8b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9600a3694fb2ddfd9853ad13bbca3d086e3179879486b8377700c6940d6e8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bab0bf2988b897706ef59bfd95fc58492137d357a18488186d8fd2ad6267a47"
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
