class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "5c12d379a08de6483e8c7b7503c3b317cc639c8ecbd8015b8d415ec98018328a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1d800ac082a0a40d91da8d515d6b19d07331f431127c48d2d13caf9a57fba8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1a8af97b11f83ce30c91e9c7f1d9917fc40dfd7cf4d6b666af9ae81ca9fec23"
    sha256 cellar: :any_skip_relocation, monterey:       "99f5ab5230bcc10ac6f06e46f523be2226bf251bd079e4635453f016c60dd790"
    sha256 cellar: :any_skip_relocation, big_sur:        "97a686d0d5e992de88ada7a0505b37a0ae561508bcf9563d4d91a28822dc410e"
    sha256 cellar: :any_skip_relocation, catalina:       "8732d22ec340a5a1ea5cd1cfd9d70bb6f36cd062085ee6078faffdb758013f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "653bc0517a20763347a6c1b55881551316c13f5b4a18be178bdaf4f7c2e6441f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"
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

    assert_equal("level=info msg=\"File parsed\" path=#{testpath}/test.yaml rules=1\n",
                 shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1"))
  end
end
