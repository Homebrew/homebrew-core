class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "48ae1b3686292f19bb007d70af5455db916ab6d39a1ee6c0fe6a27f69917f5c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe89f4281b441d9aa15ba7231ba3725ba40ed93150c0288a3cbf499f9f5f840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f751630550c8a99475e47c33ff0b7367b8d44ba38a6fe0908b38fc6d1a551bc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660e9db85c93c59e720802f1faaac824cfadedce09a2d331af97d62a2a8edd54"
    sha256 cellar: :any_skip_relocation, ventura:        "127f1f416a75a8d95016dd9489288ef7c8b00f2ff33a2bf91df2b51315b87736"
    sha256 cellar: :any_skip_relocation, monterey:       "68fbe3d3e47a5379a0bdd08416c52c41e728d1ac221bd5044121150a83aed6af"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a2422e21d40bcb49e086e534f90ec1b5a29c2eaeb48b0a7cac85ea4fe16fae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbd21fa19e41957b23b261f0631b31e97a67360919f1a8418e709a2fde94922"
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
