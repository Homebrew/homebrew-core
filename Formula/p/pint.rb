class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.89.3.tar.gz"
  sha256 "1841c4789f83feaa0ae616209465b8620e3e5186ee98284f5b0014a16d6ab556"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e538f7f0e509e4fab7c146b4ee31bd02e5f30ed87c9e57b3a6c8df831cc55135"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f69a6f3aff621a0fe9041c078c9d2311c700ba290047a53cb65e483a602e3733"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc90023ddfbbc9dda43d921979607657bdd75d41bb486a5b0d776936c2ebb60e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0589849efd5c690afb8ff107828ff193c279572219cca88eba88845b7abec9f8"
    sha256 cellar: :any,                 x86_64_linux:      "1481da82e8e007ce5a9fb9a20c3aa6ebef462db8b94151e98bc9d95cc6e987e0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pint"

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
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
