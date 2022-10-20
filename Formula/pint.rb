class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "2124afc6fee385c12ac754ee66ac6e27fb7792e1d0fa24643c5502990bf1bf57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f9f1c4773ca6782a56e2d6993f83ffeaca23995322fcc28e11b9d8ee48ebd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70fc1f24b6b358a6aa09a8620b5a0fd3ed84f3856dfd073d12f2dd59845a7cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "1d817cc399b8efe868babf28aad86862e769a3f1eb0ea25f1a5edc78081e6d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb843ded4f86bfab5a1668f2382b96b21c6ca631d4bb76b5cb290763c722663"
    sha256 cellar: :any_skip_relocation, catalina:       "db17d2b51025b519250734392bb9c865eff566b1694c3ea171a7fbb86773f1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcde87bc5d21e3018ff9deee6da26dfb70996bb5dc957a1a9177a2e5943b9e0f"
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
