class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "6b7ccbd00e4aae2c44c32471be6f868ae3769b2cfd0d92e15791951e8d9aea00"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec2779ef188c77b92b89f757b88ae9f6676f2ae9c99c2fd13ec5bbe59127f657"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3250765b7d91b84bd58ba926c4159e65ebe019c1dd8ec9711daffd5d54107f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18f2f0f4717dd3a89cf1f665ab5922d2e75f22357cacf8cbd7405a0a9c29fe9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1950a7470ca453a20b22f0d590b053247f963799afd27e63d1aed657e04c8ed1"
    sha256 cellar: :any,                 x86_64_linux:      "37e0a10392e18da12d575112b7bf4447436558e9251ee76e2a623448998c65d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/krakend/krakend-ce/v3/pkg.Version=#{version}
      -X github.com/luraproject/lura/v3/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    assert_match "KrakenD Version: #{version}", shell_output("#{bin}/krakend version 2>&1")

    (testpath/"krakend_unsupported_version.json").write <<~JSON
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    JSON
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~JSON
      {
        "version": 4,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
      {
        "version": 4,
        "extra_config": {
          "telemetry/logging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "backend": [
              {
                "url_pattern": "/backend",
                "host": [
                  "http://some-host"
                ]
              }
            ]
          }
        ]
      }
    JSON
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
