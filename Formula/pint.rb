class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "dc5215efa32314ffa1b993251d6d0cdaa5256d1bf638a48701112a09d538bf06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f7ade3c00dc9ff95f0114d0e4f2e8cc89103445ebda388c1d4e44194c8cee47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f330fe180c851ff01278e770448e4cfd6f6fc871c5a25871bbb1e5cec0ab1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b710eb83cffb905f28ee38c70b78aa8215a198c3e725bd150e40d839c55897e"
    sha256 cellar: :any_skip_relocation, monterey:       "e459687eee17dd00609940aec37a77deadc7ecfc566aebd28285862de277fddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "93f83868e27dcabdd4d2772bbe662ff241409b6269ad50666ce1ec8c8f66d908"
    sha256 cellar: :any_skip_relocation, catalina:       "47b0951bdbca92e21d1120b5ba0aaec08a5f6487406434b6653806f6af62d030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23399164c9e71d5fd63b633671cf9be7a51a881b78b7153927435cedb6aa768"
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
