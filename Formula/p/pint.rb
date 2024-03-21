class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "1a686aa7ac4dd1c354a8eb6ac26e75d267d6eaa702b64e4161592e597f25b1db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd545df68161d879da6c9f668d9947fe179f21b8fe843f3c29dcab4d948c514e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae9a499a8a65686a3189cd99dbefc519ecfb60f96d4335035fd4510bfc98a83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9e2e257c1c2e5691e13a9a42be83520f90e874f371d55adfb94d217abea5ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "6abb56e281c21bb772a922994200603e43ce567de2fc7991f00d4db8df75b3e5"
    sha256 cellar: :any_skip_relocation, ventura:        "63ee0af2e638c1a3c4bd2c5af84d5d84ee24147863e2f70f2f2c1607f2f9ebdf"
    sha256 cellar: :any_skip_relocation, monterey:       "08aaed6b3215d2463d6d3f990b1d9e8c801dd9d8174457620720e1d51b5eb912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87bb1d90858b99f6cfad73b1dc63d09d7650e0282877365b69d7e13393a727c7"
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
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
