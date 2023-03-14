class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "48ae1b3686292f19bb007d70af5455db916ab6d39a1ee6c0fe6a27f69917f5c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28b2aa90841878b08aae13517dda5825d1914a1f17d7a68e6c894fab910c7482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b881acacedd1a3af5da7fd529ba3d0482d4e478368269c878bf8087e767d01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f50eaf6ad664dbb0ea5fe1bea1f4c27a0a5aac07b3591de462c5f6ce71bbdb"
    sha256 cellar: :any_skip_relocation, ventura:        "e372b5d3d394a6258ee6896aac4684f9f69e2d5bfe3d69d13e7898ee226c12c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b2dfa0ea0038a8afc2e6602d53da35e33893673c9a8f2ef7844bedaf1e542369"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d06424e3cfa4be3bdf946181ad164e6906ab1dc5be912cb485f2ff0e0902049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e519e0631f52b34f3a351997c71a95a41ee80ee498c914ba95ee28fe9ca389f"
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
