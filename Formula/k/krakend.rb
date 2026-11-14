class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "6c91c6ed85092e32ff46d73a3aae6ab9b3823d511bc3eec33f6c260d77e8c8cc"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c57d1d7ff4177f6df85fa217a5c13ba9580e4cb2121b8e75f476bcb076963d1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5babe04dc5e4d95e6c4de93453f3b41700b2d91093e9b88d23678d0d0fae2830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc367f620746c85de87ed31721bfac01e51cf80362652ec6c0e5c2c3e443882c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8a383a42b37907d7982e8aef1405ce908da8acd3623494330f4dfa1e9aaa87b"
    sha256 cellar: :any,                 x86_64_linux:      "9d3ddb6c2870fcf74c16c32d8ce1a843190bba118ea1eb166d9dd3ad57469f8e"
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
